Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F16366DCB
	for <nvdimm@lists.linux.dev>; Wed,  4 Mar 2026 03:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772595332; cv=none; b=PJOWdj33PKtk27H+W3k1nDoxgC11yPgqt5DnHiBzTKr0WRhjfP/jJQQK7FKVg3/E9MaUjL43/AxBxtTugqS5mVtJN+TJ7+w+BWrTgAt8cnaEC4e457gk/5x/3ZbadeHDDPtaht+E6O0jjJbbWo8mNCCedPqQ//lQ3Oo2td4xio4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772595332; c=relaxed/simple;
	bh=5U4WAL8lBXF+Lq40TR+pGo77zaTrt0GzILynMS3Jnhg=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=tmleRCCHxc8RDr3ak88+eeut7osZ34AVy0XaYaP1weyKQ6TJgnJePOzisbIKZ7ZW/T+sgdjQrb4+0d/KAYBZ7O8NLqi8Q1faGT+J3qo24tSAD/UIE6dP3f0cznTaUFUg36Wf2KGg0264DE6Vn04GknlN80MsKurc5QPM5gX3cjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+b2E6ta; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+b2E6ta"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c70b5594f4so663363685a.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Mar 2026 19:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772595326; x=1773200126; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnjYftgarvMzQgRumESEYee0oJTXSMKbk9U/XxxjiSc=;
        b=V+b2E6task27szyUwG4PmVmGrK1TO9Hpk2eRzPFzL9vX9QvwxFB/m2Ad3cgq22fQOA
         rU/Ep0gSd6dpJp/CEqrsHWROi9pTjflO9R/8xOzhSvJTK0STyUZ3PIX6KPU60uyhnznk
         8So1Bu+4lRa7+KNwNJVD6qHV6xKo+eJ90sSOWxigBeqQDscJqFBhlbE25thAfKLyKj8D
         xPqxAXP1B9liOK8eSKnhFvkW3/dwTrwkLortltXtZD0jmgiNdq8BxQRpsjVKy/X18cjY
         umvltnghYsHhbJK8vEfTkYxVjTBZreQ4sWqieOaUrPYxGpe0inwBqozVT+jZ7/jdGP2S
         YbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772595326; x=1773200126;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pnjYftgarvMzQgRumESEYee0oJTXSMKbk9U/XxxjiSc=;
        b=mzN6HfwappYb8srw5Btyzed4TlO4KrFWrriZBzVW32DNnXuOx1IWlTjAhVqoHD+keV
         uiZgjkZJFTOKvswmwsf/KNpAHaZXMLwnijqun5Jw/2XWvGOUAClV9xdGWYJvAfIJToQP
         kaxLLxRfONwt1mhSk/knmeLupBSwu3mltAS2ucVu8zKT98NQt2oevTOIxMd0FWCAXdHf
         GiuDxQuKY1VCGUWjSUbUdpTLEqhqupQtVAU5JCbsHjJMWWz3Q4Aw+hRP6cERftxIm0QD
         AWqk9CanSp2L8/3W+ANFmepIh0If9jrGSMh07M9pkXiqIS3L7n/Bdf/UusZNhFQHZ6cu
         E9Kw==
X-Gm-Message-State: AOJu0YyACF5tXnFr5ZDw1s2VJBR4P2MfeHR4xjJdG3ctiCQcBqaEWO/m
	Yl3C6A84LD8sMDegFB6t1FYLdqwHi3pqf3Pdt49t65PdhLEL4adAam5xJIWjspfYCbI=
X-Gm-Gg: ATEYQzwWy468mK88R4CVjGo3oFEp2dKG6mzVVc7cgqzlkysS+Djr9x6H75wLqc50DBx
	Xhu1OEDTe7Dno+JJ0WfuKz8UhUHCIQE16BTKNi88C+dH0VkcgZ/CRnXwyqAr39eONVZZlZKiDZr
	6ERmGtKXiEmelxaJjr/aRzi3NkMoM7CQ/hZnAzuA7SYIoqu60nNU/N1wmbXGDwChKrHwZ1i4gMW
	caOFVM0gaoUO0DqLGgiVwZ7PbMH96ro3/FKFN9+CdxwzIp3ePpbYCJ9sBGdzeKDe7f5CqMjkAQb
	DUt41DkSa3wNzGb+QUYghKVWkQpYkNqRM1Im8suUSKdIMfk9VXgObXxJtOb7XMP/PgaIwQcOjKa
	A9Glf20Tb+JHAizfmYobx0bZFz1euQIHqy87vRfsx1dYCtpozQf5WjbxEGwnkO/V19/oe3lljcJ
	gI9b0EN9nsFlwR/oZShRD0Z6R/d8MT7qXxV0N6
X-Received: by 2002:a05:620a:1a8b:b0:883:647b:6dec with SMTP id af79cd13be357-8cd5b239019mr71966785a.3.1772595326286;
        Tue, 03 Mar 2026 19:35:26 -0800 (PST)
Received: from [104.39.103.200] ([104.39.103.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf68a0fbsm1502007385a.22.2026.03.03.19.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 19:35:25 -0800 (PST)
Message-ID: <8855544b-be9e-4153-aa55-0bc328b13733@gmail.com>
Date: Tue, 3 Mar 2026 22:35:25 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Dingisoul <dingiso.kernel@gmail.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com
Subject: [BUG]: KASAN: slab-use-after-free in nd_async_device_register on
 commit 3609fa95fb0f2c1b099e69e56634edb8fc03f87c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Kernel maintainers,

Our tool found a new kernel bug KASAN: slab-use-after-free in
nd_async_device_register on commit 3609fa95fb0f2c1b099e69e56634edb8fc03f87c
(Sun Jan 4 16:57:47 2026).
Please see the details below.

We observe such an error-triggering execution path in function
nd_async_device_register.

static void nd_async_device_register(void *d, async_cookie_t cookie)
{
         struct device *dev = d;
                                 // 1. The device refcount is 2.
         if (device_add(dev) != 0) {
                 dev_err(dev, "%s: failed\n", __func__);
                 put_device(dev);// 6. Refcount drops to 1.
         }
         put_device(dev);        // 7. Refcount drops to 0, dev is freed.
         if (dev->parent)        // 8. Accesses the freed "dev",
                             // triggering the use-after-free.
                 put_device(dev->parent);
}

int device_add(struct device *dev)
{
         ...
         int error = -EINVAL;
         ...
         dev = get_device(dev);   // 2. Refcount increases to 3.
         if (!dev)
                 goto done;

         if (!dev->p) {
                 error = device_private_init(dev); // 3. Fails inside.
                 if (error)
                         goto done;
         }
         ...
done:
         put_device(dev);         // 5. Refcount drops to 2.
         return error;
}

static int device_private_init(struct device *dev)
{
         dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);// 4. Allocation 
fail.
         if (!dev->p)
                 return -ENOMEM;
         dev->p->device = dev;
         klist_init(&dev->p->klist_children, klist_children_get,
                   klist_children_put);
         INIT_LIST_HEAD(&dev->p->deferred_probe);
         return 0;
}


By allowing the allocation to fail inside device_private_init(),
the bug can be stably triggered in QEMU, generating the following KASAN 
report:

[T131] ==================================================================
[T131] BUG: KASAN: slab-use-after-free in nd_async_device_register 
(drivers/nvdim
m/bus.c:495)
[T131] Read of size 8 at addr ffff88810d2a4858 by task kworker/u9:3/131
[T131]
[T131] CPU: 0 UID: 0 PID: 131 Comm: kworker/u9:3 Not tainted 
6.19.0-rc4-g3609fa95
fb0f-dirty #35 PREEMPT(full)
[T131] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.15.0-1 04/01
/2014
[T131] Workqueue: async async_run_entry_fn
[T131] Call Trace:
[T131]  <TASK>
[T131]  dump_stack_lvl (lib/dump_stack.c:122)
[T131]  print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
[T131]  kasan_report (mm/kasan/report.c:597)
[T131]  nd_async_device_register (drivers/nvdimm/bus.c:495)
[T131]  async_run_entry_fn (./arch/x86/include/asm/jump_label.h:37 
kernel/async.c
:131)
[T131]  process_scheduled_works (kernel/workqueue.c:? 
kernel/workqueue.c:3340)
[T131]  worker_thread (./include/linux/list.h:381 kernel/workqueue.c:946 
kernel/w
orkqueue.c:3422)
[T131]  kthread (kernel/kthread.c:465)
[T131]  ret_from_fork (arch/x86/kernel/process.c:164)
[T131]  ret_from_fork_asm (arch/x86/entry/entry_64.S:256)
[T131]  </TASK>
[T131]
[T131] Freed by task 131:
[T131]  kasan_save_track (mm/kasan/common.c:58 mm/kasan/common.c:78)
[T131]  kasan_save_free_info (mm/kasan/generic.c:587)
[T131]  __kasan_slab_free (mm/kasan/common.c:287)
[T131]  kfree (mm/slub.c:6670 mm/slub.c:6878)
[T131]  device_release (drivers/gpu/drm/vkms/vkms_configfs.c:745)
[T131]  kobject_put (lib/kobject.c:? lib/kobject.c:720 
./include/linux/kref.h:65
lib/kobject.c:737)
[T131]  nd_async_device_register (drivers/nvdimm/bus.c:495)
[T131]  async_run_entry_fn (./arch/x86/include/asm/jump_label.h:37 
kernel/async.c
:131)
[T131]  process_scheduled_works (kernel/workqueue.c:? 
kernel/workqueue.c:3340)
[T131]  worker_thread (./include/linux/list.h:381 kernel/workqueue.c:946 
kernel/w
orkqueue.c:3422)
[T131]  kthread (kernel/kthread.c:465)
[T131]  ret_from_fork (arch/x86/kernel/process.c:164)
[T131]  ret_from_fork_asm (arch/x86/entry/entry_64.S:256)
[T131]
[T131] The buggy address belongs to the object at ffff88810d2a4800
[T131]  which belongs to the cache kmalloc-1k of size 1024
[T131] The buggy address is located 88 bytes inside of
[T131]  freed 1024-byte region [ffff88810d2a4800, ffff88810d2a4c00)
