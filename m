Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03841160
	for <nvdimm@lists.linux.dev>; Sat, 19 Mar 2022 20:23:33 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id m12so13843392edc.12
        for <nvdimm@lists.linux.dev>; Sat, 19 Mar 2022 13:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5YBNsxl5O8OjH2sr4HE0uJPUnsdUOKQXD3xknPdXIY=;
        b=bOOFRP6xSsoA76rGxc18liWvd6CENO8KiZaH9WBzvqy/kpb1wfp7DPWO9o3MmF/S5j
         9aFygXyWTEUjBmvjN+cCohc/y0djLiB56yC60ZgVwa/R3N5ulnRGX5D+SqNagHpnhxwb
         CvdbSOg2lomk83+rFozULMLMHENWrvYtDyXnPaF+pZaQRpInBZ0rEdzORcbweS3bbgJQ
         VOLW7onzBU2ejM79A2p/lwasSRiX7GQFcXdl4KJ0r6p/EGrHdZ41ijoTa5zPBGgWU5gG
         AF+caRHNiU4gJPt3vEdTp1hf8IWEe5qXRivu6s7r8twUC3dT3iT3pqjAkGgx0nEU7HKg
         n5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5YBNsxl5O8OjH2sr4HE0uJPUnsdUOKQXD3xknPdXIY=;
        b=x/c/Pr7zR+wbtlI8sblSdtQm0fxtRhc1NS5TwOpYAycL+hdNmeVQOP+/xov56fB2+m
         x9PvVuajxc0CAgPL+lHQLklWFSHelxqfvnBN+RTSL++xES63TFl5VTHOJ2RntCC9yNZO
         mrHmqX4m3OF3sonvjDQ3uNWMJrX3XEz7bEVUk8YQDv9Px/h4S663aADnNuTdW69tzpEL
         lq1lRlLNGD9vOQY00BU2Qlr/1rRs9s4rvqOUhv8lu9ErI9SNeaLkchPQib8HmsIGTAAD
         /ToV5iUT/H0HKvJ2QrLv+ddmi/pYYsdTCuw0IZhhUDxefjySimxWHI7sqvswR1+4UEhd
         DytA==
X-Gm-Message-State: AOAM532BpS8cdEOuiAT/+DrNZlWqeJrHDSvgc4/QGgDiUXRJwXg6tda9
	91SiriRACkCRfMr+gYE+euU=
X-Google-Smtp-Source: ABdhPJx2PdrLXRfCldCSj9l4Oje3CiwNVRZ7VEJcrxo9OIQglaG89X6rafHfCAsZbL6Yf/P9pOAilw==
X-Received: by 2002:aa7:db94:0:b0:410:f0e8:c39e with SMTP id u20-20020aa7db94000000b00410f0e8c39emr15711743edt.14.1647721412224;
        Sat, 19 Mar 2022 13:23:32 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id z22-20020a17090655d600b006d229436793sm5113308ejp.223.2022.03.19.13.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 13:23:31 -0700 (PDT)
From: Jakob Koschel <jakobkoschel@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
	Cristiano Giuffrida <c.giuffrida@vu.nl>,
	"Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH] libnvdimm/namespace: only call list_move() if list element was found
Date: Sat, 19 Mar 2022 21:23:27 +0100
Message-Id: <20220319202327.2523821-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to limit the scope of the list iterator to the list
traversal loop, use a dedicated pointer pointing to the found element [1].

If no break is hit or the list is empty, 'label_ent' will be a bogus
pointer computed based on the head of the list.

In such a case &label_ent->list == &nd_mapping->labels, which will break
the list properties when passed to list_move(). Therefore list_move()
is only called if it is actually guaranteed that an element was found
within the list iteration.

Link: https://lore.kernel.org/all/YhdfEIwI4EdtHdym@kroah.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/nvdimm/namespace_devs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index b57a2d36c517..b2841e723bc3 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1894,15 +1894,17 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct nd_namespace_label *nd_label = NULL;
 		u64 hw_start, hw_end, pmem_start, pmem_end;
-		struct nd_label_ent *label_ent;
+		struct nd_label_ent *label_ent = NULL, *iter;

 		lockdep_assert_held(&nd_mapping->lock);
-		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-			nd_label = label_ent->label;
+		list_for_each_entry(iter, &nd_mapping->labels, list) {
+			nd_label = iter->label;
 			if (!nd_label)
 				continue;
-			if (nsl_uuid_equal(ndd, nd_label, pmem_id))
+			if (nsl_uuid_equal(ndd, nd_label, pmem_id)) {
+				label_ent = iter;
 				break;
+			}
 			nd_label = NULL;
 		}

@@ -1930,7 +1932,8 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 		}

 		/* move recently validated label to the front of the list */
-		list_move(&label_ent->list, &nd_mapping->labels);
+		if (label_ent)
+			list_move(&label_ent->list, &nd_mapping->labels);
 	}
 	return 0;
 }

base-commit: 34e047aa16c0123bbae8e2f6df33e5ecc1f56601
--
2.25.1

