Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEFD384
	for <nvdimm@lists.linux.dev>; Wed, 13 Sep 2023 01:10:25 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d7ec535fe42so5439256276.1
        for <nvdimm@lists.linux.dev>; Tue, 12 Sep 2023 18:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694567425; x=1695172225; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iTSTWXZd+Qc8kQEsl400yBzqT1y2zESnQaxG1xsvJaA=;
        b=F1+n1Cfl957tyZWD5mTTAopAizd0mi3nDp45rz0LCg5PUAsJi1s4dSuVYgUMBpZGUv
         dgQ6TU5TetcENggGY7jdVZ38bdhs/hf0AvUiRlYyDoGGlVjkZ8v9Dl/C2tWvqIuYUZab
         eJsMclEWtsM30odVqN7SI545EkiiZSW0JCDQIm0cbgRlfLP1svD+BDSjE2FHPxTcwUA0
         m3EqB8xDD5E/QAQJxEaPOUn9Ve6eyJA2A2nR17QEq6GzmbFRTC+oX62brvdp1Yba/XSU
         P+FiIEXFW1n/ElRkhohHztsljOmUGCKZzIYED0KxGelHTehsjpldbbuj+yN7uL7cuEYF
         sSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694567425; x=1695172225;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iTSTWXZd+Qc8kQEsl400yBzqT1y2zESnQaxG1xsvJaA=;
        b=ZWhBYwwUyYJfgpzI9WJKnaHcRB7cSURjr/tRWRhSsNhwJIr1qufQfV6C51ql3A+6uV
         rIc5K+dMGX8BGd9TKFMn/qXwgkDo3cYyg9mZCwOm0uuWPywM1VxlTMl0ltagYkdxBgKI
         5l1UV4IENLq2kM2Zj5MQApY9alpnDrCNyHhZ5wfqQVklA0DgHY09+YhoRYz3+CWqsrkp
         N+yTx89VB6ryzJzGkX4ayI+cSqrmCGqf4y6G4MIPyqb+0t4mwDgc2ioSCCSOnnCZglIA
         EM01NQBMWXHn69+m4BOG5f0r2WlmbT0837AUlORhCod0dYQ5uDQOfR4cluL900z/pXZj
         ZXqw==
X-Gm-Message-State: AOJu0YzTQPMZGH/2grx78LIcgbr+C/dKTcIAO+1AQpTEPgq2kmQ0tkYP
	+QaVJT5Lu11njBhNmygy2NS4Vo2GCGqQ3JddDw==
X-Google-Smtp-Source: AGHT+IHukZFxy/YRGdSU7QLzuMJsFp1hyiIUjVxzrzp0P2y3eo8C8hd88kGz9ROOjKOkKNpxqDSw1PChJL8Vq8X8Dg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:341:0:b0:d08:ea77:52d4 with SMTP
 id 62-20020a250341000000b00d08ea7752d4mr21572ybd.12.1694567424762; Tue, 12
 Sep 2023 18:10:24 -0700 (PDT)
Date: Wed, 13 Sep 2023 01:10:24 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAP8LAWUC/x3MQQ5AMBBA0avIrE2iLQuuIhbaDmZTMoMQcXeN5
 Vv8/4CSMCl0xQNCJyuvKcOUBYRlTDMhx2ywlXVVaxzqLilsN0bhk0Qxjhf6QzHgZCw50ziqaw+ 534Qmvv53P7zvByxhMlhrAAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1694567423; l=1658;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=XVfRHzQuTBImCvXBurgaSYSr/Vjhen73sLf0hYhbk6Y=; b=Nx9E2Hb33C+dWpKRT232WwVU71QYhrtm0y8h6goM40QFhf4jRRWy8F4BVjnwubJR1AIB0krEx
 FTrQFMQi11GBea3GQmmqXOBkt1UaYJlHxwHtukgb+LQAlVQEJL2lTSt
X-Mailer: b4 0.12.3
Message-ID: <20230913-strncpy-drivers-dax-bus-c-v1-1-bee91f20825b@google.com>
Subject: [PATCH] dax: refactor deprecated strncpy
From: Justin Stitt <justinstitt@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

`strncpy` is deprecated for use on NUL-terminated destination strings [1].

We should prefer more robust and less ambiguous string interfaces.

`dax_id->dev_name` is expected to be NUL-terminated and has been zero-allocated.

A suitable replacement is `strscpy` [2] due to the fact that it
guarantees NUL-termination on the destination buffer. Moreover, due to
`dax_id` being zero-allocated the padding behavior of `strncpy` is not
needed and a simple 1:1 replacement of strncpy -> strscpy should
suffice.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 0ee96e6fc426..1659b787b65f 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -103,7 +103,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 		if (action == ID_ADD) {
 			dax_id = kzalloc(sizeof(*dax_id), GFP_KERNEL);
 			if (dax_id) {
-				strncpy(dax_id->dev_name, buf, DAX_NAME_LEN);
+				strscpy(dax_id->dev_name, buf, DAX_NAME_LEN);
 				list_add(&dax_id->list, &dax_drv->ids);
 			} else
 				rc = -ENOMEM;

---
base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
change-id: 20230913-strncpy-drivers-dax-bus-c-f12e3153e44b

Best regards,
--
Justin Stitt <justinstitt@google.com>

