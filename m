Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4797621E2DA69
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 18:12:44 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id l82so14383326ywc.2
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 18:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h01os0Gc6bYmaGdMXt5q4G4zfirNRPWG3=gQi5POrpmg@mail.gmail.com>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815124250.GG27505@quack2.suse.cz>
 <CAPcyv4h01os0Gc6bYmaGdMXt5q4G4zfirNRPWG3=gQi5POrpmg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Aug 2017 18:15:08 -0700
Message-ID: <CAPcyv4hNe6FiAUGV7nZGAz_DAyQLEAHD_ANqt2jU8ZmUJpHJ7Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
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
To: Jan Kara <jack@suse.cz>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 15, 2017 at 9:29 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Aug 15, 2017 at 5:42 AM, Jan Kara <jack@suse.cz> wrote:
>> On Mon 14-08-17 23:12:22, Dan Williams wrote:
>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>>> index ff151814a02d..73fdc0ada9ee 100644
>>> --- a/include/linux/mm_types.h
>>> +++ b/include/linux/mm_types.h
>>> @@ -306,6 +306,7 @@ struct vm_area_struct {
>>>       struct mm_struct *vm_mm;        /* The address space we belong to. */
>>>       pgprot_t vm_page_prot;          /* Access permissions of this VMA. */
>>>       unsigned long vm_flags;         /* Flags, see mm.h. */
>>> +     unsigned long fs_flags;         /* fs flags, see MAP_DIRECT etc */
>>>
>>>       /*
>>>        * For areas with an address space and backing store,
>>
>> Ah, OK, here are VMA flags I was missing in the previous patch :) But why
>> did you create separate fs_flags field for this? on 64-bit archs there's
>> still space in vm_flags and frankly I don't see why we should separate
>> MAP_DIRECT or MAP_SYNC from other flags?
>
> Where would MAP_DIRECT go in the 32-bit case?
>
>> After all a difference in these
>> flags must also prevent VMA merging (which you forgot to handle I think)
>> and they need to be copied on split (which happens by chance even now).
>
> Ah, yes I did miss blocking the merge of a vma with MAP_DIRECT and one
> without. However, the vma split path looks ok.

The merge path already blocks merging vmas that have the ->close()
operation defined in is_mergeable_vma().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
