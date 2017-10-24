Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA38A21CEB127
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 12:10:52 -0700 (PDT)
Date: Tue, 24 Oct 2017 15:14:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm log writes: Add support for inline data buffers
Message-ID: <20171024191431.GA22902@redhat.com>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 20 2017 at  1:24am -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Currently dm-log-writes supports writing filesystem data via BIOs, and
> writing internal metadata from a flat buffer via write_metadata().
> 
> For DAX writes, though, we won't have a BIO, but will instead have an
> iterator that we'll want to use to fill a flat data buffer.
> 
> So, create write_inline_data() which allows us to write filesystem data
> using a flat buffer as a source, and wire it up in log_one_block().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Hi,

I picked this up but tweaked some whitespace and couple style nits, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.15/dm&id=6a697d036324c7fbe63fb49599027269006161e7

Thanks,
Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
