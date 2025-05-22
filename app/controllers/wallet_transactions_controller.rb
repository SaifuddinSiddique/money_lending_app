class WalletTransactionsController < ApplicationController
    def wallet_history
        @transactions = current_user.wallet_transactions.order(created_at: :desc).paginate(page: params[:page], per_page: 18)
    end
end
