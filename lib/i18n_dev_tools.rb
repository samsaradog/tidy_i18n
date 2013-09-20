module I18nDevTools

  def self.project_root=(path)
    @project_root = path
  end

  def self.project_root
    @project_root
  end

  def self.translate(key, options={})
    if key[0] == "."
      key_prefix = caller[0].
        gsub("#{project_root}/", "").
        split(".").
        first.
        gsub("/", ".")
      I18n.translate("#{key_prefix}.#{key}", options)
    else
      I18n.translate(key, options)
    end
  end

end
