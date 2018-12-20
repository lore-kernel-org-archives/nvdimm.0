Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBA81211A2DB8
 for <linux-nvdimm@lists.01.org>; Wed, 19 Dec 2018 17:42:08 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id i20so128868otl.0
 for <linux-nvdimm@lists.01.org>; Wed, 19 Dec 2018 17:42:08 -0800 (PST)
MIME-Version: 1.0
References: <46441800c43f029757c70d8386e3112701081503.1534160958.git.yi.z.zhang@linux.intel.com>
 <1534787638.13739.52.camel@intel.com>
 <89e7bd54-4afa-614d-ec54-49af7928d6c7@intel.com>
 <20180821161657.GA22028@tiger-server>
 <CAPcyv4gZ8WBhUZkoUd1m6bCrtKW0EmfWfCtpGULvjfM=yJ9_sg@mail.gmail.com>
 <20181213061239.GA43404@tiger-server>
In-Reply-To: <20181213061239.GA43404@tiger-server>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Dec 2018 17:41:56 -0800
Message-ID: <CAPcyv4iYEqrm49Nx78Ax+KaU2CqoZPxaQDQeqCxYzE+PHofr=w@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] device-dax: check for vma range while dax_mmap.
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
To: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, "Zhang, Yu C" <yu.c.zhang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, zwisler@kernel.org, Jan Kara <jack@suse.cz>Zhang,
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 12, 2018 at 10:12 PM Yi Zhang <yi.z.zhang@linux.intel.com> wrote:
>
> On 2018-12-10 at 16:10:31 -0800, Dan Williams wrote:
> > On Tue, Aug 21, 2018 at 12:38 AM Yi Zhang <yi.z.zhang@linux.intel.com> wrote:
> > >
> > > On 2018-08-20 at 12:50:31 -0700, Dave Jiang wrote:
> > > >
> > > >
> > > > On 08/20/2018 10:53 AM, Verma, Vishal L wrote:
> > > > >
> > > > > On Mon, 2018-08-13 at 20:02 +0800, Zhang Yi wrote:
> > > > >> This patch prevents a user mapping an illegal vma range that is larger
> > > > >> than a dax device physical resource.
> > > > >>
> > > > >> When qemu maps the dax device for virtual nvdimm's backend device, the
> > > > >> v-nvdimm label area is defined at the end of mapped range. By using an
> > > > >> illegal size that exceeds the range of the device dax, it will trigger a
> > > > >> fault with qemu.
> > > > >>
> > > > >> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > > > >> ---
> > > > >>  drivers/dax/device.c | 29 +++++++++++++++++++++++++++++
> > > > >>  1 file changed, 29 insertions(+)
> > > > >>
> > > > >
> > > > > Looks good to me:
> > > > > Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> > > >
> > > > Applied.
> > > Thanks Dava and Vishal's kindly review. Thank you.
> >
> > So, it turns out this patch did not get merged for 4.20. I fumbled it
> > when returning from vacation. However, I'm not sure it is needed. As
> > long as attempts to access the out-of-range capacity results in SIGBUS
> > then the implementation is correct. This is similar to the case where
> > a file is truncated after the vma is established. That size is
> > validated at fault time.
> The problem is that we didn't get the fault at we initial the mapping
> until attempt to access it, then qemu will failed unexpect without any
> output, I think is is better to mention user that we are starting at a
> illegal size, but not faulting at an uncertained time.

That can always happen with mmap'd files. There is no guarantee that a
file range an application successfully mmap'd can be faulted in
without triggering a SIGBUS later. So this change would make
device-dax semantics stricter than regular file semantics. For example
the following program prints "map: pass" and then terminates with
SIGBUS. The "test_data" file is a zero sized file.

int main(void)
{
        int fd = open("test_data", O_RDWR);
        void *addr;

        if (fd < 0)
                return -1;

        addr = mmap(NULL, 1 << 20, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
        printf("map: %s\n", addr == MAP_FAILED ? "fail" : "pass");

        *(char *) addr = 0;

        return 0;
}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
