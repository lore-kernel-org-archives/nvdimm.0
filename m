Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CACE8BE8
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 10:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683626824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Z1/LEOfzazbUDXCUcMcYiXAApu7xyk6sfdJaxyPlPeQ=;
	b=BDTZTcwzXKu5UIdtdCgiZYlmc2A2Hz4apNPyDXM7K4D9r3D7WYxJMpgSM9nm8EG9SH4mzo
	Zpmfp/J8I1Pyj9p13mmiLu0WQkABemT8YEOY+ax2oUoZ69hVdJLSGRcyd1II7fhpjzCaVS
	n9oHHZioYPWzATzg6uAF/DPTRdZaPmI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-pcADkCOyMke9fO1kZ3wwEA-1; Tue, 09 May 2023 06:07:03 -0400
X-MC-Unique: pcADkCOyMke9fO1kZ3wwEA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-24df4ef0603so2976410a91.2
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 03:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626821; x=1686218821;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z1/LEOfzazbUDXCUcMcYiXAApu7xyk6sfdJaxyPlPeQ=;
        b=dzK4J8+FKeBSNcRfa0qqWT/KHML2otVaNXbjY5X6ddWIVBEeTi6yFQnzW128KU8Vp5
         j20DTAr4Ye4Aj/okTL6Yl9zmJKWJtajoa3KFcp7sDpubTd3WvBgdhW9mmh1lWeYYa+P4
         Y34uOi+heZaraVUgxyazL2kkOEm4XUOZ9HZrvqAcJD4hxJ+whrp9pIdRcTHIT9Ttpj5g
         N1ulM1jYPjseXmhSMrDWszwU5S0851UmbzicZe33iE2QRT9xSCmE9RamkYRuufKIKxWA
         6AvZZdsIYiiu7VpYXkf/SpgrzofjdcSM7z6wmeyPCNA0B7/rC6eEUb2KK0wS+kCyy9Fe
         dFvg==
X-Gm-Message-State: AC+VfDzg9vOjBZwGY5Aqpd2RbvTZPI5FovVQX9PGRKft+NeAd4C/Urfm
	FnnHj/yyiufu0A0OvwWvKIydtZ03KmReico5JjAATcPpKiCqMVlfVe0hVxil571j+6A1kCzCIBO
	tn1yjASq07rbElVFbT7oCPq0gkA7tt5if+b9Ay47ZNyDtDw==
X-Received: by 2002:a17:90a:8807:b0:249:842d:312f with SMTP id s7-20020a17090a880700b00249842d312fmr13633166pjn.4.1683626821597;
        Tue, 09 May 2023 03:07:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5iZg+oR/nTg0OPr0t3WHbkCJrgLxgiKBsttmDFQpkOevXmCbNNfIV7yjXxT1nOUvLpy4lhJEzQGY4qptd9i6o=
X-Received: by 2002:a17:90a:8807:b0:249:842d:312f with SMTP id
 s7-20020a17090a880700b00249842d312fmr13633148pjn.4.1683626821270; Tue, 09 May
 2023 03:07:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Tue, 9 May 2023 18:06:49 +0800
Message-ID: <CAHj4cs8ULh1vMZPCudTa7W_qTeCTLYnsVWM6ybicG5g5YghJPQ@mail.gmail.com>
Subject: [bug report] kmemleak observed after running ndctl test suite
To: Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hello

Bellow kmemleak was observed after running the ndctl test suite on the
latest linux tree,
pls help check it and let me know if you need any testing/info about it, thanks.

# dmesg | grep kmemleak
[ 1508.068668] kmemleak: 28 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)
[ 1955.149091] kmemleak: 1 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)

# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff8883297984c0 (size 32):
  comm "ndctl", pid 9449, jiffies 4295135511 (age 1283.953s)
  hex dump (first 32 bytes):
    00 b0 fe 0b 01 00 00 00 00 01 00 00 00 00 00 00  ................
    30 c9 14 99 82 88 ff ff 90 3d 1b 08 93 88 ff ff  0........=......
  backtrace:
    [<ffffffff8617a677>] kmalloc_trace+0x27/0xe0
    [<ffffffffc0ebf875>] badrange_add+0x65/0x1c0 [libnvdimm]
    [<ffffffffc176b9b8>] __kstrtabns_cxl_core_test+0x82b1/0x13491 [cxl_core]
    [<ffffffffc0e9dc78>] __nd_ioctl+0xaa8/0xe70 [libnvdimm]
    [<ffffffffc0e9e1e5>] nd_ioctl+0x195/0x2b0 [libnvdimm]
    [<ffffffff864231d8>] __x64_sys_ioctl+0x128/0x1a0
    [<ffffffff87db91b9>] do_syscall_64+0x59/0x90
    [<ffffffff87e000aa>] entry_SYSCALL_64_after_hwframe+0x72/0xdc
unreferenced object 0xffff888230c1d6c0 (size 32):
  comm "modprobe", pid 10241, jiffies 4295239448 (age 1180.362s)
  hex dump (first 32 bytes):
    03 00 00 00 a0 0a 00 00 00 a0 6e 00 00 c9 ff ff  ..........n.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8617a677>] kmalloc_trace+0x27/0xe0
    [<ffffffffc176a499>] __kstrtabns_cxl_core_test+0x6d92/0x13491 [cxl_core]
    [<ffffffff86fa2d9c>] platform_probe+0x9c/0x150
    [<ffffffff86f9b76f>] really_probe+0x3df/0xb50
    [<ffffffff86f9c07a>] __driver_probe_device+0x18a/0x450
    [<ffffffff86f9c399>] driver_probe_device+0x49/0x120
    [<ffffffff86f9c8e0>] __driver_attach+0x1e0/0x4a0
    [<ffffffff86f95b70>] bus_for_each_dev+0xf0/0x170
    [<ffffffff86f98f0d>] bus_add_driver+0x29d/0x570
    [<ffffffff86f9f093>] driver_register+0x133/0x460
    [<ffffffffc1652509>] _sub_I_65535_1+0x219/0xd10 [dax_cxl]
    [<ffffffff85802829>] do_one_initcall+0xf9/0x4d0
    [<ffffffff85cab233>] do_init_module+0x233/0x730
    [<ffffffff85caf67b>] load_module+0x165b/0x2140
    [<ffffffff85cb0622>] __do_sys_finit_module+0x102/0x190
    [<ffffffff87db91b9>] do_syscall_64+0x59/0x90
unreferenced object 0xffff8882321f3340 (size 32):
  comm "modprobe", pid 11392, jiffies 4295321086 (age 1098.726s)
  hex dump (first 32 bytes):
    03 00 00 00 a0 0a 00 00 00 a0 6e 00 00 c9 ff ff  ..........n.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8617a677>] kmalloc_trace+0x27/0xe0
    [<ffffffffc1a92499>] 0xffffffffc1a92499
    [<ffffffff86fa2d9c>] platform_probe+0x9c/0x150
    [<ffffffff86f9b76f>] really_probe+0x3df/0xb50
    [<ffffffff86f9c07a>] __driver_probe_device+0x18a/0x450
    [<ffffffff86f9c399>] driver_probe_device+0x49/0x120
    [<ffffffff86f9c8e0>] __driver_attach+0x1e0/0x4a0
    [<ffffffff86f95b70>] bus_for_each_dev+0xf0/0x170
    [<ffffffff86f98f0d>] bus_add_driver+0x29d/0x570
    [<ffffffff86f9f093>] driver_register+0x133/0x460
    [<ffffffffc071d509>] 0xffffffffc071d509
    [<ffffffff85802829>] do_one_initcall+0xf9/0x4d0
    [<ffffffff85cab233>] do_init_module+0x233/0x730
    [<ffffffff85caf67b>] load_module+0x165b/0x2140
    [<ffffffff85cb0622>] __do_sys_finit_module+0x102/0x190
    [<ffffffff87db91b9>] do_syscall_64+0x59/0x90

-- 
Best Regards,
  Yi Zhang

