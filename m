Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A542821959CB2
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 08:25:19 -0700 (PDT)
Subject: Re: [PATCH 1/4] mm: Provide kernel parameter to allow disabling page
 init poisoning
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234341.4068.26882.stgit@localhost.localdomain>
 <20180912141053.GL10951@dhcp22.suse.cz>
 <CAKgT0UdvhV7U5Zniq=KskXz2QsRP8C7ctr5=ZtJwYAVpBT-RHw@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <841e8101-40db-9ff2-f688-5f175d91fc31@intel.com>
Date: Wed, 12 Sep 2018 08:23:58 -0700
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdvhV7U5Zniq=KskXz2QsRP8C7ctr5=ZtJwYAVpBT-RHw@mail.gmail.com>
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
To: Alexander Duyck <alexander.duyck@gmail.com>, mhocko@kernel.org
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, jglisse@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 09/12/2018 07:49 AM, Alexander Duyck wrote:
>>> +     page_init_poison=       [KNL] Boot-time parameter changing the
>>> +                     state of poisoning of page structures during early
>>> +                     boot. Used to verify page metadata is not accessed
>>> +                     prior to initialization. Available with
>>> +                     CONFIG_DEBUG_VM=y.
>>> +                     off: turn off poisoning
>>> +                     on: turn on poisoning (default)
>>> +
>> what about the following wording or something along those lines
>>
>> Boot-time parameter to control struct page poisoning which is a
>> debugging feature to catch unitialized struct page access. This option
>> is available only for CONFIG_DEBUG_VM=y and it affects boot time
>> (especially on large systems). If there are no poisoning bugs reported
>> on the particular system and workload it should be safe to disable it to
>> speed up the boot time.
> That works for me. I will update it for the next release.

FWIW, I rather liked Dan's idea of wrapping this under
vm_debug=<something>.  We've got a zoo of boot options and it's really
hard to _remember_ what does what.  For this case, we're creating one
that's only available under a specific debug option and I think it makes
total sense to name the boot option accordingly.

For now, I think it makes total sense to do vm_debug=all/off.  If, in
the future, we get more options, we can do things like slab does and do
vm_debug=P (for Page poison) for this feature specifically.

	vm_debug =	[KNL] Available with CONFIG_DEBUG_VM=y.
			May slow down boot speed, especially on larger-
			memory systems when enabled.
			off: turn off all runtime VM debug features
			all: turn on all debug features (default)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
