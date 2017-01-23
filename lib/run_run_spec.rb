require 'rspec/core'
require 'rspec/core/formatters/base_text_formatter'

class RunRunSpec < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_pending, :example_failed, :start_dump

  attr_accessor :progress_count, :success_count, :failed_count, :max_length

  def initialize(output)
    super output

    self.progress_count = 0
    self.success_count = 0
    self.failed_count = 0
    self.max_length = IO.console.winsize.last
  end

  def increment
    self.progress_count += 1
  end

  def increment_success_count
    self.success_count += 1
  end

  def increment_failed_count
    self.failed_count += 1
  end

  def example_passed(_notification)
    increment
    increment_success_count

    output.print RSpec::Core::Formatters::ConsoleCodes.wrap(hashiru, :success)

    back_pointer(hashiru)
  end

  def example_pending(_notification)
    increment

    output.print RSpec::Core::Formatters::ConsoleCodes.wrap(tomaru, :pending)

    back_pointer(tomaru)
  end

  def example_failed(_notification)
    increment
    increment_failed_count

    output.print RSpec::Core::Formatters::ConsoleCodes.wrap(korobu, :failure)

    back_pointer(korobu)
  end

  def start_dump(_notification)
    if self.failed_count.zero?
      output.print RSpec::Core::Formatters::ConsoleCodes.wrap(goal, :success)
    else
      output.print RSpec::Core::Formatters::ConsoleCodes.wrap(failed, :failure)
    end
  end

  def now_position
    (self.max_length / @example_count.to_f * self.success_count).to_i
  end

  def back_pointer(str)
    strs = str.split("\n")
    line_num = strs.count

    output.print "\e[#{line_num}A"
  end

  def goal
    <<-"EOF"
#{' ' * (now_position - 8)}  　|>
#{' ' * (now_position - 8)}　○ﾉ|
#{' ' * (now_position - 7)}\/|　
#{'_' * (now_position - 7)}\/ >__
    EOF
  end

  def failed
    <<-"EOF"
#{adjust_str(' ', '', 7, '  ')}
#{adjust_str(' ', '', 7, '|>')}
#{adjust_str('_', ' _|￣|○_', 8, '|_')}
    EOF
  end

  def hashiru
    effect_line = self.progress_count % 2 == 0 ? '==' : '  '

    <<-"EOF"
#{adjust_str(' ', effect_line + ' ヘ○ﾉ', 7, '  ')}
#{adjust_str(' ', effect_line + '   ﾉ ', 7, '|>')}
#{adjust_str('_', effect_line + '／＞_', 9, '|_')}
    EOF
  end

  def tomaru
    <<-"EOF"
#{adjust_str(' ', ' ヘ○ヘ', 7, '')}
#{adjust_str(' ', '  |∧ ', 7, '|>')}
#{adjust_str('_', '/__', 7, '|_')}
    EOF
  end

  def korobu
    <<-"EOF"
#{adjust_str(' ', '', 7, '')}
#{adjust_str(' ', '', 7, '|>')}
#{adjust_str('_', ' ヽ＿○ﾉ ', 9, '|_')}
    EOF
  end

  def adjust_str(padstr, printstr, rpad, endstr)
    rpad_length = self.max_length - (printstr.length + now_position + rpad)
    if rpad_length < 0
      "#{padstr * (now_position + rpad_length)}#{printstr}#{endstr}"
    else
      "#{padstr * now_position}#{printstr}#{padstr * rpad_length}#{endstr}"
    end
  end
end
