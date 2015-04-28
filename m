Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 28 Apr 2015 05:56:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Linux-nvdimm] [PATCH 12/21] nd_pmem: add NFIT support to the
 pmem driver
Message-ID: <20150428125632.GD30852@infradead.org>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150418013618.25237.99555.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150418063829.GA29931@lst.de>
 <CAPcyv4hXX-nYM7GZ6rUsZsOdgcwV1zkNv1ee8Ve-O=mzU+uf6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hXX-nYM7GZ6rUsZsOdgcwV1zkNv1ee8Ve-O=mzU+uf6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Apr 18, 2015 at 12:37:09PM -0700, Dan Williams wrote:
> At this point in the patch series I agree, but in later patches we
> take advantage of nd bus services.  "[PATCH 15/21] nd: pmem label sets
> and namespace instantiation" adds support for labeled pmem namespaces,
> and in "[PATCH 19/21] nd: infrastructure for btt devices" we make pmem
> capable of hosting btt instances.

Thats fine, but still doesn't require moving it around.
