# Copyright 2014 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file contains environment-variable overrides to be used in conjunction
# with bdutil_env.sh in order to deploy a Hadoop cluster with Tajo installed
# and configured. 
# Usage: ./bdutil -e hadoop2,tajo deploy

# URIs of Tajo tarball to install.
# Recommended Tajo version: Apache Tajo 0.11.0 or higher (eg. gs://your_bucket/tajo-x.xx.x.tar.gz)
TAJO_TARBALL_URI='gs://tajo_release/tajo-0.11.0.tar.gz'

# Tajo root directory
TAJO_ROOT_DIR="gs://${CONFIGBUCKET}/tajo"

# Tajo heap memory
# Default is 'total_memory - 1024' (MB)
MASTER_HEAPSIZE=
WORKER_HEAPSIZE=

# Task min memory of Tajo worker
# Default is 3000 (MB)
WORKER_RESOURCE_MEMORY=

# Meta store (catalog) setting of Tajo.
# Default meta store of Tajo is Derby.
# To set the catalog of Tajo for Google cloud SQL or MySQL, need the following variables.
# Host or IP of D/B Server.
CATALOG_HOST=
# The account ID of D/B.
CATALOG_ID=
# The account password of D/B.
CATALOG_PW=
# The D/B name of catalog.
CATALOG_DB=tajo

INSTALL_JDK_DEVEL=true

# Tajo will be installed in this directory on each VM
TAJO_INSTALL_DIR='/home/hadoop/tajo-install'

if [ `expr "$HADOOP_CONF_DIR" : '.*etc/hadoop'` = 0 ]
then
  echo "Not Supported Hadoop-1 (-e hadoop2,tajo)"
  exit 1
fi

COMMAND_GROUPS+=(
  "install_tajo:
     extensions/tajo/install_tajo.sh
  "
  "configure_tajo:
     extensions/tajo/configure_tajo.sh
  "
  "start_tajo:
     extensions/tajo/start_tajo.sh
  "
)

COMMAND_STEPS+=(
  'install_tajo,install_tajo'
  'configure_tajo,configure_tajo'
  'start_tajo,*'
)

