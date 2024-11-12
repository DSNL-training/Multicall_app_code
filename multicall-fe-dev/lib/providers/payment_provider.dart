import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';

class PaymentProvider extends BaseProvider {
  int accountId = 0;
  int profileRefNumber = 0;
  String profilePhoneNumber = "";
  String profileEmail = "";
  int profileCrnNumber = 0;
  int jobId = 0;

  int planId = 0;
  String planDuration = "";
  String planName = "";
  double planRechargeAmount = 0.0;
  String planStateCode = "";
  String paymentCurrency = "INR";

  int addonPlanId = 0;
  String addonPlanDuration = "";
  String addonPlanName = "";
  int addonPlanRechargeAmount = 0;

  String profileName = "";
  String address1 = "";
  String city = "";
  String state = "";
  String country = "";
  String postalCode = "";
  String gstNumber = "";

  double totalAmountWithoutGST = 0;
  int totalAmount = 0;

  int sgst = 0;
  int cgst = 0;
  int igst = 0;

  int cgstAmount = 0;
  int sgstAmount = 0;
  int igstAmount = 0;

  String paymentGatewayUrl = "";
  String redirectUrl = "";
  String cancelUrl = "";
  String mobilePaymentGatewayUrl = "";

  addPaymentGatewayDetails(
    String paymentGatewayUrlValue,
    String redirectUrlValue,
    String cancelUrlValue,
    String mobilePaymentGatewayUrlValue,
  ) {
    paymentGatewayUrl = paymentGatewayUrlValue;
    redirectUrl = redirectUrlValue;
    cancelUrl = cancelUrlValue;
    mobilePaymentGatewayUrl = mobilePaymentGatewayUrlValue;
  }

  addProfileDetails(
    int accountIdValue,
    int profileRefNumValue,
    int profileCRNValue,
  ) {
    accountId = accountIdValue;
    profileRefNumber = profileRefNumValue;
    profileCrnNumber = profileCRNValue;

    notifyListeners();
  }

  addAddonPlanDetails(
    addonPlanIdValue,
    addonPlanDurationValue,
    addonPlanNameValue,
    addonPlanRechargeAmountValue,
  ) {
    addonPlanId = addonPlanIdValue;
    addonPlanDuration = addonPlanDurationValue;
    addonPlanName = addonPlanNameValue;
    addonPlanRechargeAmount = addonPlanRechargeAmountValue;
    notifyListeners();
  }

  addPlanDetails(
    int planIdValue,
    planDurationValue,
    String planNameValue,
    double planRechargeAmountValue,
    int jobIdValue,
  ) {
    jobId = jobIdValue;
    planId = planIdValue;
    planDuration = planDurationValue;
    planName = planNameValue;
    planRechargeAmount = planRechargeAmountValue;

    notifyListeners();
  }

  addGstValues(
    int cgstValue,
    int sgstValue,
    int igstValue,
    int cgstValues,
    int sgstValues,
    int igstValues,
    int totalAmountValue,
  ) {
    cgst = cgstValue;
    sgst = sgstValue;
    igst = igstValue;
    totalAmount = totalAmountValue;
    cgstAmount = cgstValues;
    sgstAmount = sgstValues;
    igstAmount = igstValues;
    notifyListeners();
  }

  addBillingDetails(
    String profilename,
    String address,
    String cityName,
    String stateName,
    String countryName,
    String postalcodeValue,
    String gstcode,
    String planStateCodeValue,
  ) {
    profileName = profilename;
    address1 = address;
    city = cityName;
    state = stateName;
    country = countryName;
    postalCode = postalcodeValue;
    gstNumber = gstcode;
    planStateCode = planStateCodeValue;
    notifyListeners();
  }

  clear() {
    accountId = 0;
    profileRefNumber = 0;
    profilePhoneNumber = "";
    profileEmail = "";
    profileCrnNumber = 0;
    jobId = 0;
    regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber);
    email = PreferenceHelper.get(PrefUtils.userEmail);
    telephone = PreferenceHelper.get(PrefUtils.userPhoneNumber);

    planId = 0;
    planDuration = "";
    planName = "";
    planRechargeAmount = 0.0;
    planStateCode = "";
    paymentCurrency = "INR";

    profileName = "";
    address1 = "";
    city = "";
    state = "";
    country = "";
    postalCode = "";
    gstNumber = "";

    totalAmountWithoutGST = 0;
    totalAmount = 0;

    notifyListeners();
  }
}
