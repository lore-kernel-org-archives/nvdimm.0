Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70DA52205BE9B
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 13:46:48 -0800 (PST)
Received: by mail-oi0-x242.google.com with SMTP id r63so34124781oia.6
 for <linux-nvdimm@lists.01.org>; Tue, 02 Jan 2018 13:51:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180102214450.GU5858@dastard>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102214450.GU5858@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 13:51:49 -0800
Message-ID: <CAPcyv4iaSnWFd6qt52+TQ_k9Kwf1pXLq8GMHdtd-Hg_mvN6rvg@mail.gmail.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 2, 2018 at 1:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
>> In support of testing truncate colliding with dma add a mechanism that
>> delays the completion of block I/O requests by a programmable number of
>> seconds. This allows a truncate operation to be issued while page
>> references are held for direct-I/O.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Why not put this in the generic bio layer code and then write a
> generic fstest to exercise this truncate vs direct IO completion
> race condition on all types of storage and filesystems?
>
> i.e. if it sits in a nvdimm test suite, it's never going to be run
> by filesystem developers....

I do want to get it into xfstests eventually. I picked the nvdimm
infrastructure for expediency of getting the fix developed. Also, I
consider the collision in the non-dax case a solved problem since the
core mm will keep the page out of circulation indefinitely.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
