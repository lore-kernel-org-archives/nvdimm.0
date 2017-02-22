From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 07/14] infiniband: utilize new device_add_cdev
 helper function
Date: Tue, 21 Feb 2017 17:48:23 -0700
Message-ID: <20170222004823.GB11487@obsidianresearch.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-8-git-send-email-logang@deltatee.com>
 <20170221190905.GD13138@obsidianresearch.com>
 <c7d34394-a9e8-fc9f-92f5-42c56a73ad1f@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBCWOL4E62AORBR6AWPCQKGQETH77R4A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <c7d34394-a9e8-fc9f-92f5-42c56a73ad1f-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h@gm>
List-Id: linux-nvdimm@lists.01.org

On Tue, Feb 21, 2017 at 04:54:05PM -0700, Logan Gunthorpe wrote:

> Is that true? Once device_register or device_add is called then you need
> to use put_device.

General rule is once kref_init has been called then you should use
kref_put and not kfree.

device_initialize ultimately calls kref_init..

Reasoning that you don't 'need' to use put_device until device_add is
just too hard.

For instance, there is still another bug in ib_ucm_add_one:

	if (device_add(&ucm_dev->dev))
		goto err_cdev;

	if (device_create_file(&ucm_dev->dev, &dev_attr_ibdev))
		goto err_dev;
[....]
err_dev:
	device_unregister(&ucm_dev->dev);
err_cdev:
	ib_ucm_cdev_del(ucm_dev);
err:
	kfree(ucm_dev);
	return;
}

If we go down the err_dev path then device_unregister will probably
kfree ucm_dev - the argument is not guarenteed valid after
device_unregister returns - this is what makes it different from
device_del.

The simplest fix is to change the unwind into:

err_dev:
	device_del(&ucm_dev->dev);
err_cdev:
	ib_ucm_cdev_del(ucm_dev);
err:
	put_device(&ucm_dev->dev);
	return;
}

And the only way to keep our idiomatic goto unwind working is if all
'goto errs' can call put_device - which requires the device_initialize
be done before any errors are possible.

> In fact device_add is what does the first get_device so this doesn't
> add up to me.

Not quite, kref_init creates a kref with a count of 1 - eg the caller
owns the ref, and that ref must be put to trigger kref release.

Thus good kref usage should always pair a kref_put with the kref_init.

The get_device at the start of device_add pairs with the put_device at
the end of device_del and the kref_init pairs with the put_device at
the end of device_unregister. (notice that device_unregister ends up
calling put_device twice in a row..)

I'll send you a clean patch for your v2.

> I know the DAX code only uses put_device after device_add.

Looks to me like that code fails to call cdev_del if device_add fails?

This approach is problematic because it is trying do the ida removals
in the release function. That is not necessary and has the side effect
of making the release function uncallable until too late in the
process.

Jason

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
