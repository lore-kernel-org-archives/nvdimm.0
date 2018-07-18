Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4E1221BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 08:49:44 -0700 (PDT)
Subject: Re: [PATCH v5 03/12] nfit/libnvdimm: store dimm id as a member to
 struct nvdimm
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <153186086110.27463.9116313124772301223.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB116910B46B865BCCBD587195AB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <e04f87e6-5266-a140-4595-dcf1abf20ea0@intel.com>
Date: Wed, 18 Jul 2018 08:49:43 -0700
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB116910B46B865BCCBD587195AB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "Schofield, Alison" <alison.schofield@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, 'Eric Biggers' <ebiggers3@gmail.com>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 07/18/2018 08:40 AM, Elliott, Robert (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dave Jiang
>> Sent: Tuesday, July 17, 2018 3:54 PM
>> Subject: [PATCH v5 03/12] nfit/libnvdimm: store dimm id as a member to struct nvdimm
> ...
>> +if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
>> +sprintf(nfit_mem->id, "%04x-%02x-%04x-%08x",
>> +be16_to_cpu(dcr->vendor_id),
>> +dcr->manufacturing_location,
>> +be16_to_cpu(dcr->manufacturing_date),
>> +be32_to_cpu(dcr->serial_number));
>> +else
>> +sprintf(nfit_mem->id, "%04x-%08x",
>> +be16_to_cpu(dcr->vendor_id),
>> +be32_to_cpu(dcr->serial_number));
> ...
>>
>> +#define NFIT_DIMM_ID_LEN25
>> +char id[NFIT_DIMM_ID_LEN];
> 
> Since the longest ID is:
>     4+2+4+8 hex characters = 18 bytes
>     +3 dashes = 21 bytes
>     +1 NULL = 22 bytes,
> 
> why is the define 25?

It should be 22. I think I just arbitrarily gave it some more room. I'll
fix it.

> 
> Same question for this define in patch 02/12 (although there's another comment
> by Eric Biggers that this isn't really used, so this might be moot):
>> +#define NVDIMM_KEY_DESC_LEN25
> 
> 
> ---
> Robert Elliott, HPE Persistent Memory
> 
> 
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
