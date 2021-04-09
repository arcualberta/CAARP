FROM perl:latest

RUN mkdir /CAARP

COPY CAARP /CAARP

WORKDIR /CAARP

EXPOSE 3000

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    cpanminus \
    vim \
    default-mysql-server \
    default-mysql-client \
&& rm -rf /var/lib/apt/lists/*


RUN cpanm --force HTML::Widget \
    DBD::mysql \
    Catalyst::Example::Controller::InstantCRUD \
    Catalyst::Plugin::Authentication::Store::DBIx::Class

RUN cpanm --force CGI::Wiki::Formatter::Default || echo

RUN cpanm YAML::XS \
     JSON \
     Data::Dump \
     MRO::Compat \
     Template \
     Template::Context \
     Template::Timer \
     namespace::autoclean \
     Catalyst \
     Catalyst::View \
     Catalyst::Action::RenderView \
     Catalyst::Example::Controller::InstantCRUD \
     Catalyst::Authentication::Store::DBIx::Class \
     Catalyst::DispatchType::Regex \
     Catalyst::Plugin::ConfigLoader \
     Catalyst::Plugin::Authentication \
     Catalyst::Plugin::Authorization::Roles \
     Catalyst::Plugin::Authentication::Credential::Password \
     Catalyst::Plugin::Authorization::ACL \
     Catalyst::Plugin::Session \
     Catalyst::Plugin::Session::Store::File \
     Catalyst::Plugin::Session::State::Cookie \
     Catalyst::Plugin::Prototype \
     Catalyst::Plugin::FormValidator \
     Catalyst::Plugin::Static::Simple \
     Catalyst::View::JSON \
     Catalyst::View::Download::CSV \
     Catalyst::Controller \
     DBIx::Class \
     DBIx::Class::InflateColumn \
     DBIx::Class::Storage::DBI::mysql \
     DateTime::Format::MySQL \
     Moose \
     Moose::Util::TypeConstraints \
     Moose::Role \
     SQL::Statement \
     Text::CSV_XS \
     URI::Escape  \
     DateTime \
     HTML::FormHandler \
     HTML::FormHandler::Generator::DBIC \
     HTML::FormHandler::Model::DBIC \
     HTML::Entities \
     HTML::FormatText::WithLinks  \
     HTML::Widget::BlockContainer \
     Template::Plugin::DateTime \
     Spreadsheet::ParseExcel \
     YAML \
     Array::Compare \
     Geo::Coder::Google \
     Data::Random \
     Class::C3::Adopt::NEXT \
     CGI::Wiki::Formatter::Default \
     URI::Escape \
     Plack::Handler::Starman \
     Catalyst::ScriptRunner \
     LWP::Protocol::https

RUN /etc/init.d/mysql start; sleep 5; mysql < /CAARP/caarp.sql

RUN perl -I/CAARP/lib/ /CAARP/script/caarp_server.pl &
