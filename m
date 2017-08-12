Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22d.google.com (mail-yw0-x22d.google.com
 [IPv6:2607:f8b0:4002:c05::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17C8921D2DCE5
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 21:41:45 -0700 (PDT)
Received: by mail-yw0-x22d.google.com with SMTP id p68so32539561ywg.0
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 21:44:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrVvMbaxobdydtsdQWHyP1VhL1fpq1qS4M3=SmR1y4x5kw@mail.gmail.com>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <CALCETrVvMbaxobdydtsdQWHyP1VhL1fpq1qS4M3=SmR1y4x5kw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 21:44:04 -0700
Message-ID: <CAPcyv4ifFOWrfHwFhyAju1Yh89dWEeoSMoibSC30+CzoRtLNpQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
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
To: Andy Lutomirski <luto@kernel.org>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 11, 2017 at 8:57 PM, Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Aug 11, 2017 at 3:26 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Fri, Aug 11, 2017 at 3:44 AM, Christoph Hellwig <hch@lst.de> wrote:
>>> Please explain how this interface allows for any sort of safe userspace
>>> DMA.
>>
>> So this is where I continue to see S_IOMAP_IMMUTABLE being able to
>> support applications that MAP_SYNC does not. Dave mentioned userspace
>> pNFS4 servers, but there's also Samba and other protocols that want to
>> negotiate a direct path to pmem outside the kernel. Xen support has
>> thus far not been able to follow in the footsteps of KVM enabling due
>> to a dependence on static M2P tables that assume a static
>> guest-physical to host-physical relationship [1]. Immutable files
>> would allow Xen to follow the same "mmap a file" semantic as KVM.
>
> One thing that makes me quite nervous about S_IOMAP_IMMUTABLE is the
> degree to which things go badly if one program relies on it while
> another program clears the flag: you risk corrupting unrelated
> filesystem metadata.  I think a userspace interface to pin the extent
> mapping of a file really wants a way to reliably keep it pinned (or to
> reliably zap the userspace application if it gets unpinned).

In the current patches, mapping_mapped() pins the immutable state.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
