# Modeling Kernel Language (Modelyze) library
# Copyright (C) 2010-2012 David Broman

# Modelyze library is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Modelyze library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with Modelyze library.  If not, see <http://www.gnu.org/licenses/>.

# written by Oscar Eriksson oerikss@kth.se

import os
import tempfile
import logging

from OMPython import ModelicaSystem


class Model:

    _modelica_file_name = "model.mo"

    def __init__(self, model_file, moz_executable="moz"):
        self._moz_executable = moz_executable
        self._mmodel = None
        self.model = None
        self.model_file = model_file
        self.modeling_dir = tempfile.TemporaryDirectory()
        self.cwd = os.getcwd()
        logging.debug("modeling dir: %s", self.modeling_dir.name)
        logging.debug("current working dir: %s", self.cwd)

    def _go_to_modeling_dir(self):
        os.chdir(self.modeling_dir.name)
        logging.debug("changed to dir: %s", self.modeling_dir.name)

    def _go_to_cwd(self):
        os.chdir(self.cwd)
        logging.debug("changed to dir: %s", self.cwd)

    def _mk_moz_command(self, model_name):
        moz_command = f"{self._moz_executable} {self.model_file} -- -n  \
            {model_name}"

        logging.debug("moz command: %s", moz_command)
        return moz_command

    def _execute_moz(self, model_name):
        self.model = os.popen(self._mk_moz_command(model_name)).read()
        logging.debug("moz command output: \n %s", self.model)

    def _elaborate_modeyze(self, model_name):
        self._execute_moz(model_name)
        modelica_file_path = \
                f"{self.modeling_dir.name}/{self._modelica_file_name}"

        logging.debug("modelica file path: %s", modelica_file_path)
        file_descriptor = open(modelica_file_path, "w")
        file_descriptor.write(self.model)
        file_descriptor.close()
        return modelica_file_path

    def _elaborate_modelica(self, modelica_file_path, model_name):
        self._go_to_modeling_dir()
        self._mmodel = ModelicaSystem(modelica_file_path, model_name)
        self._go_to_cwd()

    def elaborate(self, model_name="Model"):
        modelica_file_path = self._elaborate_modeyze(model_name)
        self._elaborate_modelica(modelica_file_path, model_name)
        return self

    def get_parameters(self):
        return self._mmodel.getParameters()

    def set_parameters(self, **kwargs):
        self._go_to_modeling_dir()
        self._mmodel.setParameters(**kwargs)
        self._go_to_cwd()
        return self

    def simulate(self, start_time=0, stop_time=20, step_size=0.01):
        self._go_to_modeling_dir()
        self._mmodel.setSimulationOptions(
            startTime=start_time, stopTime=stop_time, stepSize=step_size, solver="ida")
        self._mmodel.simulate()
        self._go_to_cwd()
        return self

    def get_solved_variables(self):
        self._go_to_modeling_dir()
        variables = self._mmodel.getSolutions()
        self._go_to_cwd()
        return variables

    def get_solutions(self, var_list=None):
        self._go_to_modeling_dir()
        if var_list is None:
            res = self._mmodel.getSolutions(self.get_solved_variables())
        else:
            res = self._mmodel.getSolutions(var_list)
        self._go_to_cwd()
        return res
