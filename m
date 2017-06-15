Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x231.google.com (mail-ot0-x231.google.com
 [IPv6:2607:f8b0:4003:c0f::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E70521967BCC
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 13:21:31 -0700 (PDT)
Received: by mail-ot0-x231.google.com with SMTP id k4so17501748otd.0
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 13:21:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170615080738.GB1486@dhcp22.suse.cz>
References: <149739530052.20686.9000645746376519779.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149739530612.20686.14760671150202647861.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170614124520.GA8537@dhcp22.suse.cz>
 <CAPcyv4hEYJrW=Pv+ON5+EG4iLUjX2XRW3u+kSsMa8J5qh-KeVg@mail.gmail.com>
 <20170615080738.GB1486@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jun 2017 13:21:46 -0700
Message-ID: <CAPcyv4hQJ3-Qgy9ketKYyeZzd+fYixA9LhANDVtEso1HoPHFzA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: improve readability of
 transparent_hugepage_enabled()
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 15, 2017 at 1:07 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 14-06-17 12:26:46, Dan Williams wrote:
>> On Wed, Jun 14, 2017 at 5:45 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Tue 13-06-17 16:08:26, Dan Williams wrote:
>> >> Turn the macro into a static inline and rewrite the condition checks for
>> >> better readability in preparation for adding another condition.
>> >>
>> >> Cc: Jan Kara <jack@suse.cz>
>> >> Cc: Andrew Morton <akpm@linux-foundation.org>
>> >> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> >> [ross: fix logic to make conversion equivalent]
>> >> Acked-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> >
>> > This is really a nice deobfuscation! Please note this will conflict with
>> > http://lkml.kernel.org/r/1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com
>> >
>> >
>> > Trivial to resolve but I thought I should give you a heads up.
>>
>> Hmm, I'm assuming that vma_is_dax() should override PRCTL_THP_DISABLE?
>> ...and while we're there should vma_is_dax() also override
>> VM_NOHUGEPAGE? This is with the assumption that the reason to turn off
>> huge pages is to avoid mm pressure, dax exerts no such pressure.
>
> As the changelog of the referenced patch says another reason is to stop
> khugepaged from interfering and collapsing smaller pages into THP. If
> DAX mappings are subject to khugepaged then we really need to exclude
> it. Why would you want to override user's decision to disable THP
> anyway? I can see why the global knob should be ignored but if the
> disable is targeted for the specific VMA or the process then we should
> obey that, no?

I don't think DAX mappings have any interaction with THP machinery
outside of piggybacking on some of the paths in the fault handling and
the helpers to manage huge page table entries. Since DAX disables the
page cache, and all DAX mappings are file-backed I don't see a need
for a user to disable THP... does anybody else?

I think DAX != THP for any of the cases that
transparent_hugepage_enabled() cares about.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
