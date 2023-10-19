Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3328D36AF0
	for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADuE/yxo"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9cb4de3bf0so1252699276.0
        for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697738059; x=1698342859; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wCaHYSvOMmjyjjo+2DaJHIApqUGU3SdaqxSKwGR/sus=;
        b=ADuE/yxoIBp++GdL6mYy4XAp3Kx9+UClEyoVI/6+IV/TDJxZzl9o24cczzIN9iUGFK
         DNYDxuLl0qKBQ/qsQUB6ZpDh09ZlPJ5Asiag7MdmL640bZzOyWEeDVxJc29VEANscg5V
         ckYx2406aocgBLHdPyft6epjOWO8f50SCQzv20IQogDKsjLy+zhpHwhrQftmR0Bz9map
         Qi8FkxnkByyXz3Tg+hXr0nAFN/JyRbN0jnW8j2K8hYSXy0k5NT12LF/iDEsZbveoxa3t
         R9+edqlMq62+9Y0wqEkLmhluxEAa7zcNQrYmb2MEdqhSv6Z302CQ/vlpt0KrUBCRO0dj
         dpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697738059; x=1698342859;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wCaHYSvOMmjyjjo+2DaJHIApqUGU3SdaqxSKwGR/sus=;
        b=rfsiiPmOVsV2Eu5SLQcyen9/TeTIhDKP7uT+Ak+bF/Pfs95Xd+Ulf1bw4VA0+4NGhv
         Fv3TnwXS8sizxL4JoD0fF5vGBP5c5JMF5/k0PKXCgqF0t4Tr7S2Qi448uK/kZNBB4joE
         6I3WCgRiwdgNWHZTB7uZjGvHnTbPw6wfkvisZ7ju6p93RtmE6qNhWIyB4C0rrEMyoWRR
         Ngqg9TXkMr3tkz3VF0elI65yDgFVayHwjk+ZE6PBYeZwMQBBfMlZxjso1MCHHuym9MXQ
         Kgvq2+QGXfVRGElqxT5iRN3sD4jEd+rgqgcW3ahjDRDvU81yxkw9VKY3S4i9paoN/qjO
         QWwg==
X-Gm-Message-State: AOJu0Yya+C0UN8pID2rJOev/e2oY1YcTQFFDSaC9AXPm8yh0jDvvZYum
	vDzgRQqiT/nCirLqxIfcgtgpP7gpO8l3osos8w==
X-Google-Smtp-Source: AGHT+IFW/KpAD1OE2SUfMXnmaGMOttDNK0DgS3TLSfp4LYGTFI6KheySPCzP33IWgQ3o4jh68J7qlmtIbH4Cu9rxSg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:738b:0:b0:d9c:c9a8:8c27 with SMTP
 id o133-20020a25738b000000b00d9cc9a88c27mr31838ybc.13.1697738058988; Thu, 19
 Oct 2023 10:54:18 -0700 (PDT)
Date: Thu, 19 Oct 2023 17:54:15 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEZtMWUC/43NQQ6DIBCF4asY1p0GMEboqvdoXLQw6iQVzEBIj
 fHupZ6gy+8t/reLhEyYxK3ZBWOhRDFU6Esj3PwMEwL5aqGlbpVUBlLm4NYNPFNBThCKp2WBV87
 gQHWjbU1vrbEoamJlHOlz5h9D9UwpR97Ot6J+65/hokBBZ2Qvx967ztn7FOP0xquLixiO4/gCb mF4u8kAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1697738058; l=2904;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=rw760A6im3UPDmPb1PvvzFcADO0t8QLqJon9lALd7qU=; b=NYE7eTw9PMvTw2M5a8Bn23YgudGYR1Uir+9aU2nJN/yFHTP0niBKIS6Z6tV2vKAW3CaEGvUBt
 56mAEMPR1qFCvf/IQUE+DNmLbFA7xeXjbNcSzdE6VeR+EPpGWLVtRMF
X-Mailer: b4 0.12.3
Message-ID: <20231019-strncpy-drivers-nvdimm-btt-c-v2-1-366993878cf0@google.com>
Subject: [PATCH v2] nvdimm/btt: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="utf-8"

Found with grep.

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect super->signature to be NUL-terminated based on its usage with
memcmp against a NUL-term'd buffer:
btt_devs.c:
253 | if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
btt.h:
13  | #define BTT_SIG "BTT_ARENA_INFO\0"

NUL-padding is not required as `super` is already zero-allocated:
btt.c:
985 | super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
... rendering any additional NUL-padding superfluous.

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Let's also use the more idiomatic strscpy usage of (dest, src,
sizeof(dest)) instead of (dest, src, XYZ_LEN) for buffers that the
compiler can determine the size of. This more tightly correlates the
destination buffer to the amount of bytes copied.

Side note, this pattern of memcmp() on two NUL-terminated strings should
really be changed to just a strncmp(), if i'm not mistaken? I see
multiple instances of this pattern in this system:

|       if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
|               return false;

where BIT_SIG is defined (weirdly) as a double NUL-terminated string:

|       #define BTT_SIG "BTT_ARENA_INFO\0"

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
Changes in v2:
- provide more details about memcmp()
- fix typos in commit msg (thanks Kees)
- fix subject line (thanks Alison)
- Link to v1: https://lore.kernel.org/r/20231018-strncpy-drivers-nvdimm-btt-c-v1-1-58070f7dc5c9@google.com
---
Note: build-tested only.
---
 drivers/nvdimm/btt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index d5593b0dc700..9372c36e8f76 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -986,7 +986,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
 	if (!super)
 		return -ENOMEM;
 
-	strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
+	strscpy(super->signature, BTT_SIG, sizeof(super->signature));
 	export_uuid(super->uuid, nd_btt->uuid);
 	export_uuid(super->parent_uuid, parent_uuid);
 	super->flags = cpu_to_le32(arena->flags);

---
base-commit: 58720809f52779dc0f08e53e54b014209d13eebb
change-id: 20231018-strncpy-drivers-nvdimm-btt-c-15f93879989e

Best regards,
--
Justin Stitt <justinstitt@google.com>

