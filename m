Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [103.22.144.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8ECCA21A18AAA
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 03:10:56 -0700 (PDT)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 8/9] powerpc/mm: Wire up hpte_removebolted for powernv
In-Reply-To: <CAOSf1CHr2uMC1f5fMkqVpS7-J1K20cHShjp7FcNawV2KL4D_Dw@mail.gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-9-oohall@gmail.com>
 <1491961986.8380.13.camel@gmail.com>
 <CAOSf1CHr2uMC1f5fMkqVpS7-J1K20cHShjp7FcNawV2KL4D_Dw@mail.gmail.com>
Date: Thu, 13 Apr 2017 20:10:53 +1000
Message-ID: <8760i8aa8i.fsf@concordia.ellerman.id.au>
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
To: Oliver O'Halloran <oohall@gmail.com>, Balbir Singh <bsingharora@gmail.com>
Cc: Rashmica Gupta <rashmica.g@gmail.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Anton Blanchard <anton@samba.org>, Reza Arbab <arbab@linux.vnet.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Oliver O'Halloran <oohall@gmail.com> writes:
> On Wed, Apr 12, 2017 at 11:53 AM, Balbir Singh <bsingharora@gmail.com> wrote:
>>
>> The API also does not clear linear_map_hash_slots[] under DEBUG_PAGEALLOC
>
> I'm not sure what API you're referring to here. The tracking for
> linear_map_hash_slots[] is agnostic of mmu_hash_ops so we shouldn't be
> touching it here. It also looks like DEBUG_PAGEALLOC is a bit broken
> with hotplugged memory anyway so I think that's a fix for a different
> patch.

It's old and has probably bit-rotted, so I'm happy for it to be fixed up
later if necessary.

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
