Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 557B0211B6979
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 14:35:04 -0800 (PST)
Subject: Re: [PATCH v15 07/16] acpi/nfit, libnvdimm: Add unlock of nvdimm
 support for Intel DIMMs
References: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
 <154474491540.64529.6730683963766405362.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB11696C3B8B5A7E5E92608125AB810@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <6d2158ba-0c76-12dc-42b9-e11e0de34171@intel.com>
Date: Tue, 15 Jan 2019 15:35:03 -0700
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB11696C3B8B5A7E5E92608125AB810@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 1/15/19 2:56 PM, Elliott, Robert (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dave Jiang
>> Sent: Thursday, December 13, 2018 5:49 PM
>> To: dan.j.williams@intel.com
>> Cc: linux-nvdimm@lists.01.org
>> Subject: [PATCH v15 07/16] acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs
>>
>> From: Dan Williams <dan.j.williams@intel.com>
>>
> ...
>> +static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
>> +{
>> +struct device *dev = &nvdimm->dev;
>> +struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
>> +struct key *key = NULL;
>> +int rc;
>> +
>> +/* The bus lock should be held at the top level of the call stack */
>> +lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>> +
>> +if (!nvdimm->sec.ops || !nvdimm->sec.ops->unlock
>> +|| nvdimm->sec.state < 0)
>> +return -EIO;
>> +
>> +/*
>> + * If the pre-OS has unlocked the DIMM, attempt to send the key
>> + * from request_key() to the hardware for verification.  Failure
>> + * to revalidate the key against the hardware results in a
>> + * freeze of the security configuration. I.e. if the OS does not
>> + * have the key, security is being managed pre-OS.
>> + */
>> +if (nvdimm->sec.state == NVDIMM_SECURITY_UNLOCKED) {
>> +if (!key_revalidate)
>> +return 0;
>> +
>> +key = nvdimm_key_revalidate(nvdimm);
>> +if (!key)
>> +return nvdimm_security_freeze(nvdimm);
> 
> If it's already unlocked, regardless of whether nvdimm_key_revalidate()
> succeeds or fails, I'm not sure you should call nvdimm_security_freeze().
> 
> The kernel doesn't know the key, so a hands-off policy seems prudent -
> don't send any commands that change the security state.  Some other
> software (pre-OS or application) must be handling the feature, and
> sending freeze lock might interfere with that software.

The intention is that if we don't have the key or the key verification
fails, we want to prevent any additional interaction with security for
this particular boot session. At least for the Intel implementation, a
reboot will clear the freeze.

> 
> Maybe you intended that to be "if (key)", intending to freeze if the
> kernel does have the correct key (so no application can change it and
> render the kernel out of sync)?
> 
> 
>> +} else
>> +key = nvdimm_request_key(nvdimm);
>> +
>> +if (!key)
>> +return -ENOKEY;
>> +
>> +rc = nvdimm->sec.ops->unlock(nvdimm, key_data(key));
>> +dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
>> +rc == 0 ? "success" : "fail");
>> +
>> +nvdimm_put_key(key);
>> +nvdimm->sec.state = nvdimm_security_state(nvdimm);
>> +return rc;
>> +}
>> +
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
