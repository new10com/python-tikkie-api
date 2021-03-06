from typing import Optional

from tikkie2._session import ApiSession, get_session
from tikkie2.v2.models import SubscribeResponse


def subscribe(
    *,
    url: str,
    app_token: Optional[str] = None,
    api_key: Optional[str] = None,
    session: Optional[ApiSession] = None,
) -> SubscribeResponse:
    """
    Subscribes to transactions related notifications. One transaction
    subscription can be active at a time. When this request is
    repeated, the existing transaction subscription is overwritten.
    The application must have transactions permission to complete
    this request.

    https://developer.abnamro.com/api-products/tikkie/reference-documentation#tag/Transactions-notification

    :param url: URL where notifications must be sent using a webhook or callback.
    :param app_token: The App Token generated in the Tikkie Business Portal.
    :param api_key: The API Key obtained from the ABN developer portal.
    :param session: An optional API session class. If not passed the global API session will be used
    """
    s = session if session else get_session()
    payload = {"url": url}

    response = s.post(
        "transactionssubscription",
        json=payload,
        app_token=app_token,
        api_key=api_key,
    )
    return SubscribeResponse.parse_raw(response.content)


def delete(
    app_token: Optional[str] = None,
    api_key: Optional[str] = None,
    session: Optional[ApiSession] = None,
) -> None:
    """
    Deletes a subscription. The application must have transactions
    permission to complete this request.

    https://developer.abnamro.com/api-products/tikkie/reference-documentation#operation/subscribeTransactionsNotifications

    :param app_token: The App Token generated in the Tikkie Business Portal.
    :param api_key: The API Key obtained from the ABN developer portal.
    :param session: An optional API session class. If not passed the global API session will be used
    """
    s = session if session else get_session()
    s.delete(
        "transactionssubscription",
        app_token=app_token,
        api_key=api_key,
    )
