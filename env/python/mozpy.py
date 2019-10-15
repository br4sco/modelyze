import os
import tempfile
from OMPython import ModelicaSystem

class Model:

    _modelica_file_name = "model.mo"

    def __init__(self, model_file, moz_executable="moz"):
        self.model_file = model_file
        self._moz_executable = moz_executable
        self.modeling_dir = tempfile.TemporaryDirectory()
        self.cwd = os.getcwd()

    def _go_to_modeling_dir(self):
        os.chdir(self.modeling_dir.name)

    def _go_to_cwd(self):
        os.chdir(self.cwd)

    def _build_moz_command(self, model_name):
        return self._moz_executable + " " + self.model_file + " -- -n " + model_name

    def _execute_moz(self, model_name):
        return os.popen(self._build_moz_command(model_name)).read()

    def _elaborate_modeyze(self, model_name):
        modelica_file_path = self.modeling_dir.name + "/" + self._modelica_file_name
        fd = open(modelica_file_path, "w")
        fd.write(self._execute_moz(model_name))
        fd.close()
        return modelica_file_path

    def _elaborate_modelica(self, modelica_file_path, model_name):
        self._go_to_modeling_dir()
        self._mmodel = ModelicaSystem(modelica_file_path, model_name)
        self._go_to_cwd()

    def elaborate(self, model_name="Model"):
        modelica_file_path = self._elaborate_modeyze(model_name)
        self._elaborate_modelica(modelica_file_path, model_name)
        return self

    def simulate(self, t0=0, tf=20, h=0.01):
        self._go_to_modeling_dir()
        self._mmodel.setSimulationOptions(startTime=t0, stopTime=tf, stepSize=h, solver="ida")
        self._mmodel.simulate()
        self._go_to_cwd()
        return self

    def getSolvedVariables(self):
        self._go_to_modeling_dir()
        variables = self._mmodel.getSolutions()
        self._go_to_cwd()
        return variables

    def getSolutions(self, var_list=None):
        self._go_to_modeling_dir()
        if var_list is None:
            res = self._mmodel.getSolutions(self.getSolvedVariables())
        else:
            res = self._mmodel.getSolutions(var_list)
        self._go_to_cwd()
        return res
