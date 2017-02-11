Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42BB7820AC
 for <linux-nvdimm@lists.01.org>; Sat, 11 Feb 2017 00:56:33 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id j15so32493767oih.2
 for <linux-nvdimm@lists.01.org>; Sat, 11 Feb 2017 00:56:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170211071619.GA1345@kroah.com>
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
 <CAPcyv4jA-H5CykS8A_JwGM635MJSa7Bj_G__eq9RwfjFCAke5Q@mail.gmail.com>
 <20170210201737.GA15397@kroah.com>
 <CAPcyv4gz0C+rhR=Xzk-G58yM=qpEBEuYbkushn5dByFD38KQbg@mail.gmail.com>
 <20170211071619.GA1345@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Feb 2017 00:56:31 -0800
Message-ID: <CAPcyv4gpeLehh6MgwWOd6=3UckOFNdGRR4jdKjq26+Jm5xijkg@mail.gmail.com>
Subject: Re: [PATCH] device-dax: don't set kobj parent during cdev init
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 10, 2017 at 11:16 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Feb 10, 2017 at 02:25:35PM -0800, Dan Williams wrote:
>> On Fri, Feb 10, 2017 at 12:17 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Feb 10, 2017 at 11:41:20AM -0800, Dan Williams wrote:
>> >> On Fri, Feb 10, 2017 at 11:19 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>> >> > I copied this code and per feedback from Greg Kroah-Hartman [1] the
>> >> > cdev's kobject's parent should not be set to the related device.
>> >> > This should have minor consequences but isn't doing what anyone
>> >> > expects it to.
>> >> >
>> >> > This patch then fixes device-dax so it doesn't make the same mistake.
>> >> >
>> >> > [1] https://lkml.org/lkml/2017/2/10/370
>> >> >
>> >> > Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> >>
>> >> Thanks for following up with this fix, but this causes a
>> >> use-after-free regression:
>> >>
>> >>  general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>> >>  [..]
>> >>  Call Trace:
>> >>   vsnprintf+0x2d7/0x500
>> >>   snprintf+0x49/0x60
>> >>   dev_vprintk_emit+0x68/0x230
>> >>   ? debug_lockdep_rcu_enabled+0x1d/0x20
>> >>   ? trace_hardirqs_off+0xd/0x10
>> >>   ? cmpxchg_double_slab.isra.70+0x15a/0x1c0
>> >>   ? __slab_free+0x134/0x290
>> >>   dev_printk_emit+0x4e/0x70
>> >>   __dynamic_dev_dbg+0xc8/0x110
>> >>   ? __lock_acquire+0x33d/0x1290
>> >>   dax_dev_huge_fault+0xee/0x570 [dax]
>> >>   __handle_mm_fault+0x5aa/0x10a0
>> >>   handle_mm_fault+0x154/0x350
>> >>   ? handle_mm_fault+0x3c/0x350
>> >>   __do_page_fault+0x26b/0x4c0
>> >>   trace_do_page_fault+0x58/0x270
>> >>   do_async_page_fault+0x1a/0xa0
>> >>   async_page_fault+0x28/0x30
>> >>
>> >> I added this reference explicitly so the parent struct device has the
>> >> correct lifetime after this feedback from Al.
>> >>
>> >>    https://lists.01.org/pipermail/linux-nvdimm/2016-August/006563.html
>> >>
>> >> ...so I'm wondering what the actual problem is with setting cdev->parent?
>> >
>> > It shouldn't do anything at all.  The kobject in a cdev isn't a "normal"
>> > kobject, it doesn't show up in sysfs, or anywhere else.  It's used for
>> > an internal representation to the cdev code (a kmap) to look up the
>> > object to call when userspace opens the device node in a quick manner.
>> >
>> > Now changing from initialize/add to just register, does do different
>> > things, perhaps that is the issue here.  Just try removing the
>> > cdev->kobject parent stuff and see if that causes a problem or not.
>> >
>>
>>  That doesn't help.  I rely on the "kobject_get(p->kobj.parent);" in
>> cdev_add() to pin my device and cdev_default_release() to free it.
>
> "pin it" where?  Why do you need this?  That feels really "odd" to me...

If there's a more idiomatic way to achieve what drivers/dax/dax.c is
doing I'm of course open to switching...

The cdev is embedded in a struct dax_dev.

/**
 * struct dax_dev - subdivision of a dax region
 * @region - parent region
 * @dev - device backing the character device
 * @cdev - core chardev data
 * @alive - !alive + rcu grace period == no new mappings can be established
 * @id - child id in the region
 * @num_resources - number of physical address extents in this device
 * @res - array of physical address ranges
 */
struct dax_dev {
        struct dax_region *region;
        struct inode *inode;
        struct device dev;
        struct cdev cdev;
        bool alive;
        int id;
        int num_resources;
        struct resource res[0];
};

The only I/O operation that can be performed on this device file is mmap.

static const struct file_operations dax_fops = {
        .llseek = noop_llseek,
        .owner = THIS_MODULE,
        .open = dax_open,
        .release = dax_release,
        .get_unmapped_area = dax_get_unmapped_area,
        .mmap = dax_mmap,
};

When the device is unregistered it invalidates all existing mappings,
but the driver may continue to service vm fault requests until the
final put of the cdev. Until that time the fault handler needs to be
able to check dax_dev->alive. Since the final cdev put is handled by
the vfs I use the cdev's kobject to keep the struct dax_dev instance
alive.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
