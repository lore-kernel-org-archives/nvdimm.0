Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D40A21CFA5E5
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 13:27:54 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: don't control-c during ndctl create-namespace?
References: <556dc70b-2759-b483-868e-041f1be772f7@hpe.com>
 <x49inhna2lb.fsf@segfault.boston.devel.redhat.com>
 <5994A73A.9000908@hpe.com>
Date: Wed, 16 Aug 2017 16:30:18 -0400
In-Reply-To: <5994A73A.9000908@hpe.com> (Linda Knippers's message of "Wed, 16
 Aug 2017 16:12:42 -0400")
Message-ID: <x491sobs1b9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "Saldivar, Maurice A." <maurice.a.saldivar@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Linda Knippers <linda.knippers@hpe.com> writes:

> On 08/16/2017 12:40 PM, Jeff Moyer wrote:
>> [   24.311419] nvdimm nmem1: nvdimm_init_config_data: len: 131072 rc: 0
>> [   24.311420] nvdimm nmem1: config data size: 131072
>> [   24.311421] nvdimm nmem1: __nd_label_validate: nsindex0 labelsize 1 invalid
>> [   24.311422] nvdimm nmem1: __nd_label_validate: nsindex1 labelsize 1 invalid
>> [   24.311425] nvdimm nmem1: : pmem-9221e8a3: 0x1f80000000 @ 0x10000000 reserve
>> [   24.311427] nvdimm nmem1: : null: 0x0 @ 0x0 reserve
>> [   24.311428] nvdimm nmem1: nvdimm_drvdata_release
>> [   24.311430] nd_bus ndbus0: nvdimm.probe(nmem1) = -16
>> [   24.311442] nvdimm: probe of nmem1 failed with error -16
>> 
>> Trying to enable nmem1 will result in EBUSY, since we're trying to
>> reserve address 0 (see the null entry above).
>> 
>> Unlike Linda's case, I can recover by zeroing the label space.  
>
> If you have to zero your labels, it's not really recovering. Or are you
> able to recreate labels and not lose data that might have been in those
> pmem ranges?

Good point.  Due to the corrupted label, I lose everything on that DIMM.
I think Dan mentioned maybe adding the ability to clear out bad labels.
We'd be better off not getting into this state in the first place,
obviously.  ;-)

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
