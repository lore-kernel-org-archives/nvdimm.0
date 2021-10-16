Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016442C81
	for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 09:07:03 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so9066740pjb.3
        for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 02:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+kT5N/LlfyUJbC/6MhhfqyqIT+2xyqIMuaKUvu/iNs=;
        b=UlNzPDJ1h4X0fPvLjG6HjThaRzDbai+QeVe3P/h9Y0N9/V0PdDEINdBrWQaH8vOM7e
         tqkAfnaY63oIhiud678m09o4mgbI5kFxlg2zE3l9+cDIGo57g8MmI2OTBMPmW8LpLPBh
         I3WUapy9hln6hKheK2J8aZB3qiZOfggALPMy0uVm28KvBBX5lNtoDIn77Vkt5ml3J0jV
         JXtRtJ09iJYymiEthqdE5W6PjmE98KMrCU1Vj3Ef5JcMc8vt1mHzGZjMZF2hD2oNBPkV
         bCYdqTlJLwqmCkiDvEZR7C/T+pPHQdBePkBTzyeyJWuWKeZhui5OC+VcDyWOA5Z/Gwus
         AgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+kT5N/LlfyUJbC/6MhhfqyqIT+2xyqIMuaKUvu/iNs=;
        b=67sAMo6b75tz74uNSSv3tOEHA8l7cEsvYpOON7b7hZmaZEcjjN8YW+qjcLrm4PmjsJ
         6KbjpmhpFbw44dM1iLrQmid+MOrXrHbI12D7tEwnQpmoR7km1PVGSHyf1bVxdciPz/CK
         1Ta7UTMbkCugaXEXGmHZFkLgyJqVowocf9wgjJdMa+x8uSaa4NN+R50pMPSKt6DfHnHS
         qoxpPKMGspxPYwTqtc7sAxH1TC3NtWPhi3nxxSfU/l6Go+SHxZzcwH7U2leDXgfwwvdU
         2cr97GXxRwXTgy+AZhpwp1JScJoMAhKAP6jwSXAAhY6OoHXEJBJyDlo84GL2iNMmZSlp
         KUWg==
X-Gm-Message-State: AOAM53308RP8MCO0EqhEVyrN2fTPTEE+kDuDVlqU7H47WYS9mVga+x/n
	s57wd0+eH0eoh85WBuAeX0VvE0iOEBL1sA==
X-Google-Smtp-Source: ABdhPJwlpOgLSxq/zQ/sH7mIHiSorJ/2+ECev61ajwtEDnT6gS7Q075D4n7bv59xkVAegKakpayeHw==
X-Received: by 2002:a17:90a:e010:: with SMTP id u16mr33550961pjy.217.1634375223567;
        Sat, 16 Oct 2021 02:07:03 -0700 (PDT)
Received: from lb01399.pb.local ([2405:201:5506:8116:c405:d8b7:e765:cf87])
        by smtp.gmail.com with ESMTPSA id n202sm7134897pfd.160.2021.10.16.02.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 02:07:03 -0700 (PDT)
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To: nvdimm@lists.linux.dev,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com,
	david@redhat.com,
	mst@redhat.com,
	cohuck@redhat.com,
	stefanha@redhat.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	pankaj.gupta@ionos.com,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH] virtio-pmem: add myself as virtio-pmem maintainer
Date: Sat, 16 Oct 2021 11:06:46 +0200
Message-Id: <20211016090646.371145-1-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pankaj Gupta <pankaj.gupta@ionos.com>

Adding myself as virtio-pmem maintainer and also adding virtualization
mailing list entry for virtio specific bits. Helps to get notified for
appropriate bug fixes & enhancements.

Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1bd721478800..6a1ced092cfa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19941,6 +19941,13 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-virtio.c
 F:	include/uapi/linux/virtio_i2c.h
 
+VIRTIO PMEM DRIVER
+M:	Pankaj Gupta <pankaj.gupta.linux@gmail.com>
+L:	virtualization@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/nvdimm/virtio_pmem.c
+F:	drivers/nvdimm/nd_virtio.c
+
 VIRTUAL BOX GUEST DEVICE DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 M:	Arnd Bergmann <arnd@arndb.de>
-- 
2.25.1

