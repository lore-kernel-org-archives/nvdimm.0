Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13642C9C
	for <nvdimm@lists.linux.dev>; Tue, 11 Jan 2022 16:19:56 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id v123so11454928wme.2
        for <nvdimm@lists.linux.dev>; Tue, 11 Jan 2022 08:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RzDPDtmZcf1JkCwHy8uphmdNH63NACWxOruLcR+YRzM=;
        b=UmQnQGZogndZaXUFhpJa03xTCx7fBNT8VNxoUmY+UsvAfzj2fADPRqOli9HxsLMq63
         ii7NzDgjye4uYFOsiArqjt2pBrCwRqJWu+L6PSVLkB4Vg6cWL0pMnai7afMw/jDsuelo
         bkT+80SKDY6lGWcvIk1Dw+S+iDmW2k1AH/0pPm276BNE+3f0TSK/jqh/pmP7ey54Gkcl
         86HQUpAaF+jR7cMdQC1qI5PU4qJ5fGaLYBilnJ3lXBtp6zz4SXpxkYNBLtoFL4qBmBxp
         7BxitiucJawRwU6Uc37H74zRW2xVNWkx3Zh3g0DQIOEXeqs4FmhAa0ttEvZlYT3JkwAd
         dmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RzDPDtmZcf1JkCwHy8uphmdNH63NACWxOruLcR+YRzM=;
        b=JUHsOq4XBBAElm6+6Li/L7XEZsGyZgCh4yl2u6GeMR/nywVeUi3JY9+PKtNzGSi+R+
         rcjzQIZAZquM0dv2xuyCtUHOQ3XcEJbDpyIkET1J3AXlrM2ax8hTp8z2g6miFfz76e3E
         vw8Vzuqrjq96jxj4ZRm8gkmKxnEvzbz0LHtS0203ZR2q/PbLqwTxYNsXbtDOZULC4+2U
         Sby6p2e7oJp9TmOaIM3xX6bDWFz4MbBdwWhzvrZ2aCjBrnwWuquczfFX77xvd0SO19x/
         d6/6e4ibEew0aaaS7Ohmx15VnM7vuwBGbQmtBL+xcFkSCJ3zUEtagnQ/9PelmjrqjvYW
         4iQA==
X-Gm-Message-State: AOAM531pZIJpBM/eIVxZcC1gqClcEvskUAyrb6unyuIrGccqJqB0P+jS
	cMZXw7uYFIDUdKp3nG1TQblefI4JAd0=
X-Google-Smtp-Source: ABdhPJypQ2Df/GvB83RXg+sGXjQrR1aN+4Hk0+Gb5DM+pxwdBnFLVIiqG9IeU63qjXkcRKZNldxXjw==
X-Received: by 2002:a1c:cc0f:: with SMTP id h15mr3129291wmb.38.1641917995256;
        Tue, 11 Jan 2022 08:19:55 -0800 (PST)
Received: from lb01399.fkb.profitbricks.net ([85.214.13.132])
        by smtp.gmail.com with ESMTPSA id p18sm3012397wmq.0.2022.01.11.08.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 08:19:54 -0800 (PST)
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To: nvdimm@lists.linux.dev,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com,
	jmoyer@redhat.com,
	stefanha@redhat.com,
	david@redhat.com,
	mst@redhat.com,
	cohuck@redhat.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	pankaj.gupta@ionos.com,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [RFC v3 0/2] virtio-pmem: Asynchronous flush
Date: Tue, 11 Jan 2022 17:19:35 +0100
Message-Id: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 Jeff reported preflush order issue with the existing implementation
 of virtio pmem preflush. Dan suggested[1] to implement asynchronous flush
 for virtio pmem using work queue as done in md/RAID. This patch series
 intends to solve the preflush ordering issue and makes the flush asynchronous
 for the submitting thread. Also, adds the flush coalscing logic.

 Submitting this RFC v3 series for review. Thank You!

 RFC v2 -> RFC v3
 - Improve commit log message - patch1.
 - Improve return error handling for Async flush.
 - declare'INIT_WORK' only once.
 - More testing and bug fix.

 [1] https://marc.info/?l=linux-kernel&m=157446316409937&w=2

Pankaj Gupta (2):
  virtio-pmem: Async virtio-pmem flush
  pmem: enable pmem_submit_bio for asynchronous flush

 drivers/nvdimm/nd_virtio.c   | 74 +++++++++++++++++++++++++++---------
 drivers/nvdimm/pmem.c        | 15 ++++++--
 drivers/nvdimm/region_devs.c |  4 +-
 drivers/nvdimm/virtio_pmem.c | 10 +++++
 drivers/nvdimm/virtio_pmem.h | 16 ++++++++
 5 files changed, 98 insertions(+), 21 deletions(-)

-- 
2.25.1

