FROM archlinux

ENV SHELL /bin/bash
ENV USER analyst
ENV UID 1000
ENV USER_HOME /home/$USER

RUN useradd -m -s $SHELL -N -u $UID $USER
USER $USER

ENV PERLBREW_ROOT $USER_HOME/perl5
ENV PATH $PERLBREW_ROOT/bin:/opt/perl5/bin:$PATH
RUN echo "source /opt/perl5/etc/bashrc && perlbrew use perl-5.24.0" >> $USER_HOME/.bashrc

RUN source $USER_HOME/.bashrc && perlbrew init
RUN source $USER_HOME/.bashrc && perlbrew install-cpanm

RUN source $USER_HOME/.bashrc && cpanm --local-lib=$PERLBREW_ROOT Moose@2.1804
RUN source $USER_HOME/.bashrc && cpanm --local-lib=$PERLBREW_ROOT DBD::Pg@3.5.3
RUN source $USER_HOME/.bashrc && cpanm --local-lib=$PERLBREW_ROOT Catalyst::Runtime@5.90105
RUN source $USER_HOME/.bashrc && cpanm --local-lib=$PERLBREW_ROOT Catalyst::Devel@1.39
RUN source $USER_HOME/.bashrc && cpanm --local-lib=$PERLBREW_ROOT Const::Fast@0.014