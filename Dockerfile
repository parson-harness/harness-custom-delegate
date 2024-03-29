ARG DELEGATE_TAG
ARG DELEGATE_IMAGE=harness/delegate
FROM $DELEGATE_IMAGE:$DELEGATE_TAG
USER root
  
RUN microdnf update \  
  && microdnf install --nodocs \  
    unzip \  
    zip \
    yum-utils \
    git 
  
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \  
  && microdnf install -y terraform     
  
RUN mkdir /opt/harness-delegate/tools && cd /opt/harness-delegate/tools \  
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl   

RUN microdnf install jq -y  
  
ENV PATH=/opt/harness-delegate/tools/:$PATH  

# RUN useradd -u 1001 -g 0 harness

# Install serverless
RUN microdnf install -y nodejs \
  && npm install -g serverless@2.50.0
  
# Install tfenv
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv \
  && ln -s ~/.tfenv/bin/* /usr/local/bin \
  && tfenv install latest \
  && tfenv use latest

# Install Terragrunt
# RUN curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v0.42.3/terragrunt_linux_amd64 \
#  && mv terragrunt_linux_amd64 /usr/bin/terragrunt \
#  && chmod +x /usr/bin/terragrunt \
#  && terragrunt --version

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip -q awscliv2.zip \
  && ./aws/install \
  && aws --version

# Install GCP CLI
# RUN echo -e "[google-cloud-cli] \n\
# name=Google Cloud CLI \n\
# baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64 \n\
# enabled=1 \n\
# gpgcheck=1 \n\
# repo_gpgcheck=0 \n\
# gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" | tee /etc/yum.repos.d/google-cloud-sdk.repo \
#  && microdnf install google-cloud-cli \
#  && gcloud version

# Install Azure CLI
# RUN echo -e "[azure-cli] \n\
# name=Azure CLI \n\
# baseurl=https://packages.microsoft.com/yumrepos/azure-cli \n\
# enabled=1 \n\
# gpgcheck=1 \n\
# gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo && microdnf install azure-cli

# RUN curl -o- -L https://slss.io/install | bash \
#  && ln -s /opt/harness-delegate/.serverless/bin/serverless /usr/local/bin/serverless

# USER 1001
