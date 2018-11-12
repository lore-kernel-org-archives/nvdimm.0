Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66CDB21959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 12:27:35 -0800 (PST)
Subject: Re: [PATCH 10/11] tools/testing/nvdimm: add Intel DSM 1.8 support for
 nfit_test
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180167993.70506.16150690843165035447.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB11690E45D72C292B3A78C51FABC70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <180c21d7-3633-5538-f5ca-4d06431c29bd@intel.com>
Date: Mon, 12 Nov 2018 13:27:29 -0700
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB11690E45D72C292B3A78C51FABC70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 11/9/18 8:15 PM, Elliott, Robert (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
>> Dave Jiang
>> Sent: Friday, November 09, 2018 4:15 PM
>> To: dan.j.williams@intel.com; zohar@linux.vnet.ibm.com
>> Cc: linux-nvdimm@lists.01.org
>> Subject: [PATCH 10/11] tools/testing/nvdimm: add Intel DSM 1.8
>> support for nfit_test
> ...
>> +static int nd_intel_test_cmd_master_set_pass(struct nfit_test *t,
>> +struct nd_intel_set_master_passphrase *nd_cmd,
>> +unsigned int buf_len, int dimm)
>> +{
>> +struct device *dev = &t->pdev.dev;
>> +struct nfit_test_sec *sec = &dimm_sec_info[dimm];
>> +
>> +if (!(sec->ext_state & ND_INTEL_SEC_ESTATE_ENABLED)) {
>> +nd_cmd->status = ND_INTEL_STATUS_NOT_SUPPORTED;
>> +dev_dbg(dev, "master set passphrase in wrong state\n");
> 
> "master set passphrase:" for consistency

Thanks! Will update.

> 
>> +} else if (sec->ext_state & ND_INTEL_SEC_ESTATE_PLIMIT) {
>> +nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
>> +dev_dbg(dev, "master set passphrase in wrong security
>> state\n");
> 
> "master set passphrase:" for consistency
> 
>> +} else if (memcmp(nd_cmd->old_pass, sec->master_passphrase,
>> +ND_INTEL_PASSPHRASE_SIZE) != 0) {
>> +nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
>> +dev_dbg(dev, "master set passphrase wrong
>> passphrase\n");
> 
> "master set passphrase:" for consistency
> 
>> +} else {
>> +memcpy(sec->master_passphrase, nd_cmd->new_pass,
>> +ND_INTEL_PASSPHRASE_SIZE);
>> +nd_cmd->status = 0;
>> +dev_dbg(dev, "master passphrase updated\n");
> 
> "master set passphrase:" for consistency
> 
>> +}
>> +
>> +return 0;
>> +}
>> +
>> +static int nd_intel_test_cmd_master_secure_erase(struct nfit_test
>> *t,
>> +struct nd_intel_master_secure_erase *nd_cmd,
>> +unsigned int buf_len, int dimm)
>> +{
>> +struct device *dev = &t->pdev.dev;
>> +struct nfit_test_sec *sec = &dimm_sec_info[dimm];
>> +
>> +if (!(sec->ext_state & ND_INTEL_SEC_ESTATE_ENABLED)) {
>> +nd_cmd->status = ND_INTEL_STATUS_NOT_SUPPORTED;
>> +dev_dbg(dev, "master erase in wrong state\n");
> 
> "master secure erase: " for consistency
> 
>> +} else if (sec->ext_state & ND_INTEL_SEC_ESTATE_PLIMIT) {
>> +nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
>> +dev_dbg(dev, "master erase in wrong security state\n");
> 
> "master secure erase: " for consistency
> 
>> +} else if (memcmp(nd_cmd->passphrase, sec->master_passphrase,
>> +ND_INTEL_PASSPHRASE_SIZE) != 0) {
>> +nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
>> +dev_dbg(dev, "master secure erase: wrong passphrase\n");
>> +} else {
>> +memset(sec->master_passphrase, 0,
>> ND_INTEL_PASSPHRASE_SIZE);
>> +sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
>> +memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
>> +sec->state = 0;
>> +dev_dbg(dev, "master secure erase: done\n");
>> +}
>> +
>> +return 0;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
