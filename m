Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 19 Dec 2016 22:40:17 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] dev-dax: add fallocate support to clear poison
Message-ID: <20161220064017.GA8390@infradead.org>
References: <148219023506.15885.3919571427691230959.stgit@djiang5-desk3.ch.intel.com>
 <148219024781.15885.1883996216561314302.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hQdOrFoct0bCYKciWffsV511zXX3oxQKHM+4vere6VtA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hQdOrFoct0bCYKciWffsV511zXX3oxQKHM+4vere6VtA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 19, 2016 at 04:46:00PM -0800, Dan Williams wrote:
> In the case of filesystem-dax (xfs or ext4) a punch hole operation is
> effective for clearing a media error.

Which at best is a third order side effect of what it actually does:
release allocated space.  Which is something we can do on various
block devices (SCSI with thin provisioning, device mapper) as well.

> It will deallocate blocks and
> the zeroing that is performed when the blocks are reallocated will
> clear media errors. We want the same semantic for device-dax.
> FALLOC_FL_PUNCH_HOLE triggers the driver stack to clear any media
> errors, although unlike the filesystem case there are no physical
> ranges de-allocated from the device. With support for this subset of
> fallocate we can avoid needing to add a custom ioctl for similar
> functionality.

It's in no way similar functionality.  It's absuing an interface for
something entirely different.

So NAK to this series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
