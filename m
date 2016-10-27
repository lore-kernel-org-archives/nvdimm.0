Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 27 Oct 2016 05:32:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Message-ID: <20161027123219.GA757@infradead.org>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
 <20161020232239.GQ23194@dastard>
 <20161021095714.GA12209@infradead.org>
 <76e957c9-8002-5a46-8111-269bb0401718@grimberg.me>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <76e957c9-8002-5a46-8111-269bb0401718@grimberg.me>
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
To: Sagi Grimberg <sagi@grimberg.me>
Cc: jgunthorpe@obsidianresearch.com, sbates@raithin.com, "Raj, Ashok  <ashok.raj@intel.com>, haggaie@mellanox.com, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Jonathan Corbet <corbet@lwn.net>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 27, 2016 at 01:22:49PM +0300, Sagi Grimberg wrote:
> Christoph, did you manage to leap to the future and solve the
> RDMA persistency hole? :)
> 
> e.g. what happens with O_DSYNC in this model? Or you did
> a message exchange for commits?

Yes, pNFS calls this the layoutcommit.  That being said once we get a RDMA
commit or flush operation we could easily make the layoutcommit optional
for some operations.  There already is a precedence for the in the
flexfiles layout specification.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
