Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89EDF2095AE51
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 13:24:21 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id t88so5390499oij.0
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 13:26:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824163925.GA28503@lst.de>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213655.5039.7662200155640827407.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824161152.GB27591@lst.de>
 <CAPcyv4jjNi_+c5DW9nsBLEnYMBtsR_v67+bF6bC4Cb9mY7T+Ww@mail.gmail.com>
 <20170824163925.GA28503@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 13:26:55 -0700
Message-ID: <CAPcyv4j06mdEek-aYfZCbTW0MaL6gy7OpUsgyv4hBB5yy_rW6A@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xen-devel@lists.xen.org, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 9:39 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Aug 24, 2017 at 09:31:17AM -0700, Dan Williams wrote:
>> External agent is a DMA device, or a hypervisor like Xen. In the DMA
>> case perhaps we can use the fcntl lease mechanism, I'll investigate.
>> In the Xen case it actually would need to use fiemap() to discover the
>> physical addresses that back the file to setup their M2P tables.
>> Here's the discussion where we discovered that physical address
>> dependency:
>>
>>     https://lists.xen.org/archives/html/xen-devel/2017-04/msg00419.html
>
> fiemap does not work to discover physical addresses.  If they want
> to do anything involving physical address they will need a kernel
> driver.

True, it's broken with respect to multi-device filesystems and these
patches do nothing to fix that problem. Ok, I'm fine to let that use
case depend on a kernel driver and just focus on fixing the DMA case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
