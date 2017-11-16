Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8566D220D4BE0
 for <linux-nvdimm@lists.01.org>; Thu, 16 Nov 2017 13:27:42 -0800 (PST)
Date: Thu, 16 Nov 2017 14:31:47 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v3] generic: add test for DAX MAP_SYNC support
Message-ID: <20171116213147.GB27448@linux.intel.com>
References: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
 <20171025204704.3382-1-ross.zwisler@linux.intel.com>
 <20171025215638.GA30335@dastard>
 <20171116212815.GA27448@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171116212815.GA27448@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Amir Goldstein <amir73il@gmail.com>, Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 16, 2017 at 02:28:15PM -0700, Ross Zwisler wrote:
> On Thu, Oct 26, 2017 at 08:56:38AM +1100, Dave Chinner wrote:
> > Perhaps stat -c %b $SCRATCH_MNT/test ?
> 
> Maybe, but doesn't the output of 'stat -c %b' depend on the block size the
> filesystem is using?  I think to use stat I'd have to check both %b and %B,
> and account for different block sizes, or do some shell math.  I think it may
> be easier to just use du.

Ah, never mind, I think you meant 'stat -c %s' - that's cleaner, will switch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
