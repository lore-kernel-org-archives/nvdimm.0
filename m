Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x233.google.com (mail-yw0-x233.google.com
 [IPv6:2607:f8b0:4002:c05::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 339072095E012
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 10:57:03 -0700 (PDT)
Received: by mail-yw0-x233.google.com with SMTP id p68so26754439ywg.0
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 10:59:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170811105723.GA25839@infradead.org>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212399361.23722.13317531480320953298.stgit@djiang5-desk3.ch.intel.com>
 <20170811105723.GA25839@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 10:59:22 -0700
Message-ID: <CAPcyv4hAjm9nGCeZWpb3XiryT8Tkvvx6dVNoDuJYhD54TQ3pvQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] libnvdimm: Adding blk-mq support to the pmem driver
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Vinod Koul <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 11, 2017 at 3:57 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Aug 07, 2017 at 09:39:53AM -0700, Dave Jiang wrote:
>> Adding blk-mq support to the pmem driver in addition to the direct bio
>> support.
>
> Can you explain why this is only done for pmem and not btt and nd_blk?

I'm skeptical that we can get a dma offload benefit for those drivers
since we need to metadata updates and block-window management after
each I/O. Whether those drivers would benefit from an mq conversion is
a separate question, but the driving motivation for the conversion has
been that it's easier to send a 'struct request' to a dma engine than
a bio.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
