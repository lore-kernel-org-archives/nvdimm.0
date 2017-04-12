Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E94E921A0483B
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 20:30:23 -0700 (PDT)
Received: by mail-pg0-x242.google.com with SMTP id g2so2710511pge.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 20:30:23 -0700 (PDT)
Subject: Re: [PATCH 8/9] powerpc/mm: Wire up hpte_removebolted for powernv
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-9-oohall@gmail.com> <20170412085056.4da27f32@kryten>
 <20170412101819.402451e0@canb.auug.org.au>
From: Rashmica Gupta <rashmicy@gmail.com>
Message-ID: <ca08ec04-5e59-cfa5-3682-eeba7cc3b58e@gmail.com>
Date: Wed, 12 Apr 2017 13:30:18 +1000
MIME-Version: 1.0
In-Reply-To: <20170412101819.402451e0@canb.auug.org.au>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Oliver O'Halloran <oohall@gmail.com>
Cc: Rashmica Gupta <rashmica.g@gmail.com>, linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 12/04/17 10:18, Stephen Rothwell wrote:
> Hi Oliver,
>
> On Wed, 12 Apr 2017 08:50:56 +1000 Anton Blanchard <anton@samba.org> wrote:
>>> From: Rashmica Gupta <rashmica.g@gmail.com>
>>>
>>> Adds support for removing bolted (i.e kernel linear mapping) mappings
>>> on powernv. This is needed to support memory hot unplug operations
>>> which are required for the teardown of DAX/PMEM devices.
>>>
>>> Cc: Rashmica Gupta <rashmica.g@gmail.com>
>>> Cc: Anton Blanchard <anton@samba.org>
>>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>>> ---
>>> Could the original author of this add their S-o-b? I pulled it out of
>>> Rashmica's memtrace patch, but I remember someone saying Anton wrote
>>> it originally.
>> I did.
>>
>> Signed-off-by: Anton Blanchard <anton@samba.org>
> If you are going to claim that Rashmica authored this patch (and you do
> with the From: line above), then you need her Signed-off-by as well.
>
Oliver, can you change the 'From' to a 'Reviewed By'?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
