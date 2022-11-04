# frozen_string_literal: true

module Web::Repositories::ChecksHelper
  def file_path(path, repository)
    path = (path.split('/') - Rails.root.to_s.split('/')).join('/')
    link_to path, "https://github.com/#{repository.full_name}"
  end
end
