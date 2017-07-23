Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <1500818683.4073.31.camel@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
From: Rik van Riel <riel@redhat.com>
Date: Sun, 23 Jul 2017 10:04:43 -0400
In-Reply-To: <CAPcyv4gtWYpzbmggsbdLocPiMzU2rVt-ee+kL24gbrPxKd5Eyw@mail.gmail.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <945864462.33340808.1500620194836.JavaMail.zimbra@redhat.com>
 <20170721121241.GA18014@stefanha-x1.localdomain>
 <46101617.33460557.1500643755247.JavaMail.zimbra@redhat.com>
 <20170721155848.GO18014@stefanha-x1.localdomain>
 <CAPcyv4gtWYpzbmggsbdLocPiMzU2rVt-ee+kL24gbrPxKd5Eyw@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2017-07-22 at 12:34 -0700, Dan Williams wrote:
> On Fri, Jul 21, 2017 at 8:58 AM, Stefan Hajnoczi <stefanha@redhat.com
> > wrote:
> >
> > Maybe the NVDIMM folks can comment on this idea.
> 
> I think it's unworkable to use the flush hints as a guest-to-host
> fsync mechanism. That mechanism was designed to flush small memory
> controller buffers, not large swaths of dirty memory. What about
> running the guests in a writethrough cache mode to avoid needing
> dirty
> cache management altogether? Either way I think you need to use
> device-dax on the host, or one of the two work-in-progress filesystem
> mechanisms (synchronous-faults or S_IOMAP_FROZEN) to avoid need any
> metadata coordination between guests and the host.

The thing Pankaj is looking at is to use the DAX mechanisms
inside the guest (disk image as memory mapped nvdimm area),
with that disk image backed by a regular storage device on
the host.

The goal is to increase density of guests, by moving page
cache into the host (where it can be easily reclaimed).

If we assume the guests will be backed by relatively fast
SSDs, a "whole device flush" from filesystem journaling
code (issued where the filesystem issues a barrier or
disk cache flush today) may be just what we need to make
that work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
