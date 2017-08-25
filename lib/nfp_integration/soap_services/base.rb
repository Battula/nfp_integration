module NfpIntegration
  module SoapServices
    module Base

      def get_element_text(value)
        text = value.try(:first).try(:text)
        text.nil? ? "" : text.strip
      end

      def parse_statement_summary(response)
        past_due = get_element_text(response.xpath("//PastDue"))
        previous_balance = get_element_text(response.xpath("//PreviousBalance"))
        new_charges = get_element_text(response.xpath("//NewCharges"))
        adjustments = get_element_text(response.xpath("//Adjustments"))
        payments = get_element_text(response.xpath("//Payments"))
        total_due = get_element_text(response.xpath("//TotalDue"))
        result = {past_due: past_due, previous_balance: previous_balance, new_charges: new_charges, adjustments: adjustments, payments: payments, total_due: total_due}
        result
      end

      def get_most_recent_payment_date(response)

        date = get_element_text(response.xpath("//DateReceived"))
        unless (date.blank?)
          formatted_date = DateTime.parse(date).to_date.to_s
        end
      end

      def parse_current_statement
        return nil if @token.blank?

        response = current_statement_summary

        return nil if response.blank?

        past_due = get_element_text(response.xpath("//PastDue"))
        previous_balance = get_element_text(response.xpath("//PreviousBalance"))
        new_charges = get_element_text(response.xpath("//NewCharges"))
        adjustments = get_element_text(response.xpath("//Adjustments"))
        payments = get_element_text(response.xpath("//Payments"))
        total_due = get_element_text(response.xpath("//TotalDue"))

        adjustment_items = []
        response.xpath("//CurrentStatementResponse/CurrentAdjustments/Item/Item").each do |x|
          adjustment_items << {:amount => get_element_text(x.xpath(".//Amount")),
                               :name => get_element_text(x.xpath(".//Name")),
                               :type => get_element_text(x.xpath(".//Type")),
                               :description => get_element_text(x.xpath(".//Description")),
                               :status => get_element_text(x.xpath("./Status")),
                               :posting_date => get_element_text(x.xpath(".//PostingDate")),
                                }
        end

        result = {past_due: past_due, previous_balance: previous_balance,
          new_charges: new_charges, adjustments: adjustments, payments: payments,
          total_due: total_due,
          adjustment_items: adjustment_items
        }
      end

    end
  end
end
