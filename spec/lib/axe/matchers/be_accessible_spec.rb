require 'timeout'
require 'axe/matchers/be_accessible'

module Axe::Matchers
  describe BeAccessible do
    let(:audit) { spy('audit') }
    let(:results) { spy('results') }
    before :each do
      subject.instance_variable_set :@audit, audit
    end

    describe "#matches?" do
      let(:page) { spy('page') }

      it "should run the audit against the page" do
        subject.matches?(page)
        expect(audit).to have_received(:run_against).with(page)
      end

      it "should save results" do
        allow(audit).to receive(:run_against).and_return(results)

        subject.matches? page

        expect( subject.instance_variable_get :@results ).to be results
      end

      it "should return results.passed" do
        allow(audit).to receive(:run_against).and_return(results)
        allow(results).to receive(:passed?).and_return(:passed)

        expect( subject.matches?(page) ).to be :passed
      end
    end

    describe "@results" do
      before :each do
        subject.instance_variable_set :@results, results
      end

      it "should be delegated #failure_message" do
        expect(results).to receive(:failure_message).and_return(:foo)
        expect(subject.failure_message).to eq :foo
      end

      it "should be delegated #failure_message_when_negated" do
        expect(results).to receive(:failure_message).and_return(:foo)
        expect(subject.failure_message_when_negated).to eq :foo
      end
    end

    describe "#within" do
      it "should be delegated to @audit" do
        subject.within(:foo)
        expect(audit).to have_received(:include).with(:foo)
      end

      it "should return self for chaining" do
        expect(subject.within(:foo)).to be subject
      end
    end

    describe "#excluding" do
      it "should be delegated to @audit" do
        subject.excluding(:foo)
        expect(audit).to have_received(:exclude).with(:foo)
      end

      it "should return self for chaining" do
        expect(subject.excluding(:foo)).to be subject
      end
    end

    describe "#according_to" do
      it "should be delegated to @audit" do
        subject.according_to(:foo)
        expect(audit).to have_received(:rules_by_tags)
      end

      it "should accept a single tag" do
        subject.according_to(:foo)
        expect(audit).to have_received(:rules_by_tags).with([:foo])
      end

      it "should accept many tags" do
        subject.according_to(:foo, :bar)
        expect(audit).to have_received(:rules_by_tags).with([:foo, :bar])
      end

      it "should accept an array of tags" do
        subject.according_to([:foo, :bar])
        expect(audit).to have_received(:rules_by_tags).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.according_to(:foo)).to be subject
      end
    end

    describe "#checking" do
      it "should be delegated to @audit" do
        subject.checking(:foo)
        expect(audit).to have_received(:run_rules)
      end

      it "should accept a single rule" do
        subject.checking(:foo)
        expect(audit).to have_received(:run_rules).with([:foo])
      end

      it "should accept many rules" do
        subject.checking(:foo, :bar)
        expect(audit).to have_received(:run_rules).with([:foo, :bar])
      end

      it "should accept an array of rules" do
        subject.checking([:foo, :bar])
        expect(audit).to have_received(:run_rules).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.checking(:foo)).to be subject
      end
    end

    describe "#checking_only" do
      it "should be delegated to @audit" do
        subject.checking_only(:foo)
        expect(audit).to have_received(:run_only_rules)
      end

      it "should accept a single rule" do
        subject.checking_only(:foo)
        expect(audit).to have_received(:run_only_rules).with([:foo])
      end

      it "should accept many rules" do
        subject.checking_only(:foo, :bar)
        expect(audit).to have_received(:run_only_rules).with([:foo, :bar])
      end

      it "should accept an array of rules" do
        subject.checking_only([:foo, :bar])
        expect(audit).to have_received(:run_only_rules).with([:foo, :bar])
      end

      it "should return self for chaining" do
        expect(subject.checking_only(:foo)).to be subject
      end
    end

    describe "#with_options" do
      it "should be delegated to @audit" do
        subject.with_options(:foo)
        expect(audit).to have_received(:custom_options)
      end

      it "should return self for chaining" do
        expect(subject.with_options(:foo)).to be subject
      end
    end

  end
end
