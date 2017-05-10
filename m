Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4936E21959D3E
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 14:34:35 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
 <1494449841.30303.80.camel@hpe.com>
 <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
 <1494451676.30303.82.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c25539ef-f892-7f08-3f1e-c7c318c7747e@intel.com>
Date: Wed, 10 May 2017 14:34:33 -0700
MIME-Version: 1.0
In-Reply-To: <1494451676.30303.82.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 05/10/2017 02:28 PM, Kani, Toshimitsu wrote:
> On Wed, 2017-05-10 at 14:13 -0700, Dave Jiang wrote:
>>
>> On 05/10/2017 01:57 PM, Kani, Toshimitsu wrote:
>>> On Wed, 2017-05-10 at 12:56 -0700, Dave Jiang wrote:
>>>>
>>>> On 05/10/2017 11:43 AM, Kani, Toshimitsu wrote:
>  :
>>>
>>> Attached "strace.log".  Note, there is no reference to "badblocks"
>>> files in the log.
>>
>> Hmmm....is there any reason my raw namespace is different type than
>> yours? Do you know if yours hit the else branch on util/json.c:516 in
>> util_namespace_to_json()? That is the only thing I can think of that
>> would show no badblocks in the strace.
> 
> Yes, it hits the else case.  Not sure if it's related, but our raw
> device does not have any metadata so it does not have uuid.

The raw namespace is not ND_DEVICE_NAMESPACE_IO for you. Maybe that's
correlated to not having uuid? I can add dumping of badblocks to the
else branch. Essentially it's a pass through of the region badblocks for
raw ns.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
