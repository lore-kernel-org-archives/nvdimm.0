Return-Path: <SRS0=TPW+=6O=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD384C8300C
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Apr 2020 10:29:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B211C2186A
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Apr 2020 10:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GRc1AOxP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B211C2186A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 953F3111B5BC4;
	Thu, 30 Apr 2020 03:28:49 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=207.211.31.120; helo=us-smtp-1.mimecast.com; envelope-from=david@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com [207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 58786111B5BC3
	for <linux-nvdimm@lists.01.org>; Thu, 30 Apr 2020 03:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1588242596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBxdneYzv1oFt6rUtmxHP8L8tmn6FMG5Rn0MO+hCbf0=;
	b=GRc1AOxPVSP5nuHEWrXjyi/msXQ0zbqJmYJrnrUMnBMgWRZeMevzIvGaFLkugFIFcgkVrV
	QVgvBqje0bXGeEMvcM98GRSr1ODO6I1j6l2GA54ykkDm7wIHNH/tL3iW/6Q7blEJBradq6
	erGTZhdH6d8APCUbHXTN2O1RqAEuTzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-ZkDsTUQ-OxW7sjqOoV_anw-1; Thu, 30 Apr 2020 06:29:51 -0400
X-MC-Unique: ZkDsTUQ-OxW7sjqOoV_anw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 920BB45F;
	Thu, 30 Apr 2020 10:29:49 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B43035EDEB;
	Thu, 30 Apr 2020 10:29:40 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] mm/memory_hotplug: Introduce MHP_NO_FIRMWARE_MEMMAP
Date: Thu, 30 Apr 2020 12:29:07 +0200
Message-Id: <20200430102908.10107-3-david@redhat.com>
In-Reply-To: <20200430102908.10107-1-david@redhat.com>
References: <20200430102908.10107-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Message-ID-Hash: OFO4YAZXF4ATOKO7PFVAUFFQ27IPYRD7
X-Message-ID-Hash: OFO4YAZXF4ATOKO7PFVAUFFQ27IPYRD7
X-MailFrom: david@redhat.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-mm@kvack.org, virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-hyperv@vger.kernel.org, linux-s390@vger.kernel.org, xen-devel@lists.xenproject.org, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Baoquan He <bhe@redhat.com>, Eric Biederman <ebiederm@xmission.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OFO4YAZXF4ATOKO7PFVAUFFQ27IPYRD7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Some devices/drivers that add memory via add_memory() and friends (e.g.,
dax/kmem, but also virtio-mem in the future) don't want to create entries
in /sys/firmware/memmap/ - primarily to hinder kexec from adding this
memory to the boot memmap of the kexec kernel.

In fact, such memory is never exposed via the firmware memmap as System
RAM (e.g., e820), so exposing this memory via /sys/firmware/memmap/ is
wrong:
 "kexec needs the raw firmware-provided memory map to setup the
  parameter segment of the kernel that should be booted with
  kexec. Also, the raw memory map is useful for debugging. For
  that reason, /sys/firmware/memmap is an interface that provides
  the raw memory map to userspace." [1]

We don't have to worry about firmware_map_remove() on the removal path.
If there is no entry, it will simply return with -EINVAL.

[1] https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-firmware-memmap

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/memory_hotplug.h | 8 ++++++++
 mm/memory_hotplug.c            | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 0151fb935c09..4ca418a731eb 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -68,6 +68,14 @@ struct mhp_params {
 	pgprot_t pgprot;
 };
 
+/* Flags used for add_memory() and friends. */
+
+/*
+ * Don't create entries in /sys/firmware/memmap/. The memory is detected and
+ * added via a device driver, not via the initial (firmware) memmap.
+ */
+#define MHP_NO_FIRMWARE_MEMMAP		1
+
 /*
  * Zone resizing functions
  *
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c01be92693e3..e94ede9cad00 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1062,7 +1062,8 @@ int __ref add_memory_resource(int nid, struct resource *res,
 	BUG_ON(ret);
 
 	/* create new memmap entry */
-	firmware_map_add_hotplug(start, start + size, "System RAM");
+	if (!(flags & MHP_NO_FIRMWARE_MEMMAP))
+		firmware_map_add_hotplug(start, start + size, "System RAM");
 
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
-- 
2.25.3
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
