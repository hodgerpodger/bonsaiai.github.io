module Rouge
  class Token
    attr_reader :name
    attr_reader :parent
    attr_accessor :shortname

    def make_single(name)
      name = name.to_s
      new_name = [self.name, name].compact.join('.')

      new_token = self.clone
      parent = self
      new_token.instance_eval do
        @name = new_name
        @parent = parent
        @sub_tokens = {}
      end

      sub_tokens[name] = new_token

      new_token
    end

    def make(name, shortname=nil)
      names = name.split('.')
      names.inject(self) do |tok, name|
        tok.make_single(name)
      end
    end

    def [](name)
      name = name.to_s

      name.split('.').inject(self) do |tok, name|
        tok.sub_tokens[name] || tok.make_single(name)
      end
    end

    def sub_tokens
      @sub_tokens ||= {}
    end

    def ===(other)
      immediate = if self.class == other.class
        self == other
      else
        self.name == other
      end

      immediate || !!(other.parent && self === other.parent)
    end

    def inspect
      parts = [name.inspect]
      parts << shortname.inspect if shortname
      "#<Token #{parts.join(' ')}>"
    end

    class << self
      def base
        @base ||= new
      end

      def get(name)
        base[name]
      end

      def token(name, shortname)
        tok = get(name)
        tok.shortname = shortname
        tok
      end

      alias [] get
    end

    # XXX IMPORTANT XXX
    # For compatibility, this list must be kept in sync with
    # pygments.token.STANDARD_TYPES
    token 'Text',                   ''
    token 'Whitespace',             'w'
    token 'Error',                  'err'
    token 'Other',                  'x'

    token 'Keyword',                'k'
    token 'Keyword.Constant',       'kc'
    token 'Keyword.Declaration',    'kd'
    token 'Keyword.Namespace',      'kn'
    token 'Keyword.Pseudo',         'kp'
    token 'Keyword.Reserved',       'kr'
    token 'Keyword.Type',           'kt'

    token 'Name',                   'n'
    token 'Name.Attribute',         'na'
    token 'Name.Builtin',           'nb'
    token 'Name.Builtin.Pseudo',    'bp'
    token 'Name.Class',             'nc'
    token 'Name.Constant',          'no'
    token 'Name.Decorator',         'nd'
    token 'Name.Entity',            'ni'
    token 'Name.Exception',         'ne'
    token 'Name.Function',          'nf'
    token 'Name.Property',          'py'
    token 'Name.Label',             'nl'
    token 'Name.Namespace',         'nn'
    token 'Name.Other',             'nx'
    token 'Name.Tag',               'nt'
    token 'Name.Variable',          'nv'
    token 'Name.Variable.Class',    'vc'
    token 'Name.Variable.Global',   'vg'
    token 'Name.Variable.Instance', 'vi'

    token 'Literal',                'l'
    token 'Literal.Date',           'ld'

    token 'String',                 's'
    token 'String.Backtick',        'sb'
    token 'String.Char',            'sc'
    token 'String.Doc',             'sd'
    token 'String.Double',          's2'
    token 'String.Escape',          'se'
    token 'String.Heredoc',         'sh'
    token 'String.Interpol',        'si'
    token 'String.Other',           'sx'
    token 'String.Regex',           'sr'
    token 'String.Single',          's1'
    token 'String.Symbol',          'ss'

    token 'Number',                 'm'
    token 'Number.Float',           'mf'
    token 'Number.Hex',             'mh'
    token 'Number.Integer',         'mi'
    token 'Number.Integer.Long',    'il'
    token 'Number.Oct',             'mo'

    token 'Operator',               'o'
    token 'Operator.Word',          'ow'

    token 'Punctuation',            'p'

    token 'Comment',                'c'
    token 'Comment.Multiline',      'cm'
    token 'Comment.Preproc',        'cp'
    token 'Comment.Single',         'c1'
    token 'Comment.Special',        'cs'

    token 'Generic',                'g'
    token 'Generic.Deleted',        'gd'
    token 'Generic.Emph',           'ge'
    token 'Generic.Error',          'gr'
    token 'Generic.Heading',        'gh'
    token 'Generic.Inserted',       'gi'
    token 'Generic.Output',         'go'
    token 'Generic.Prompt',         'gp'
    token 'Generic.Strong',         'gs'
    token 'Generic.Subheading',     'gu'
    token 'Generic.Traceback',      'gt'
  end
end