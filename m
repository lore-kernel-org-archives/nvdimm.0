Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96593219493F2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 11:00:22 -0700 (PDT)
Date: Wed, 26 Apr 2017 12:00:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/2] dax: add regression test for stale mmap reads
Message-ID: <20170426180021.GB15921@linux.intel.com>
References: <20170425205106.20576-1-ross.zwisler@linux.intel.com>
 <20170425205106.20576-2-ross.zwisler@linux.intel.com>
 <20170426090907.q5jj3ywsvldsbq7n@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170426090907.q5jj3ywsvldsbq7n@XZHOUW.usersys.redhat.com>
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
To: Xiong Zhou <xzhou@redhat.com>
Cc: Jan Kara <jack@suse.cz>, eguan@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>, fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 26, 2017 at 05:09:07PM +0800, Xiong Zhou wrote:
> On Tue, Apr 25, 2017 at 02:51:06PM -0600, Ross Zwisler wrote:
<>
> > +	/*
> > +	 * Try and use the mmap to read back the data we just wrote with
> > +	 * pwrite().  If the kernel bug is present the mapping from the 2MiB
> > +	 * zero page will still be intact, and we'll read back zeros instead.
> > +	 */
> > +	if (strncmp(buffer, data, strlen(buffer))) {
> > +		fprintf(stderr, "strncmp mismatch: '%s' vs '%s'\n", buffer,
> > +				data);
> 		munmap
> 		close(fd);
> > +		exit(1);
> > +	}
> > +
> 	munmap

Yep, thanks, fixed in v3.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
