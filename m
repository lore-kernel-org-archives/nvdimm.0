Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C152F4315
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568656; cv=none; b=ksEYC6kLlAbzw7cu9mERSK9HPuGH8GVNJqZG2pRVF3er9Rn2Sl/3Gjpu65f94jnJGpYy/VkbI9Ilf4eW+CqnrRY3i/vV0N2XpuxKJXBrHcMb8urGVYixeBDOueL71+VQtF/B3ECdb8QQoxWZyRIo/06IPFKedyqszzon+Rws/kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568656; c=relaxed/simple;
	bh=3KazfK/QQTaTKMCPWi0YxDdEC7X6OVxJtOIOm2yyTcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kmGX0u94mV4QPwkWnbJAKBdiR+7pgC4RZuVoJvnSPxvP7ohxnorWsXmQw8JXKSnRugIgSuZnO7lplwMK5eWwfDmhjve2qEwNlOhKvDOujVlKIYQivo6iwlc01FvbE5av0mobRQuuPOTqZCkz1xRqAzpSWdg4E26YBHbIzFKtCTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kwhOtGzL; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kwhOtGzL"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7382ffcb373so158585a34.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568654; x=1752173454; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PaZvyCikUvPqtnjUjM92+A61XpmMjGb4Ba8q0a5FCxQ=;
        b=kwhOtGzLPXdHyu7HPwmaE+FO/vcCG+1lLZBtZgRAgUWLBbM05W6Qxh+Cv5Bdefho6N
         JSAl7DDZjOPppe0NinroQFrTBCgZfs7whS2R4fvZtZe8JsZK2SqbqFqqPsZ3RRrRX6nd
         428t0vxz2YRSpF3f4+RECjafs/ekGZEThmegjM9Gisi4AH/USRM3wEu8byKZfWLS15UP
         Xgkjc4WecoQ+3hSnwZ+IgIM+IvGMOzJ+L9LOHWCp4yfSTyvfAu9DrptXIquQAynB0QVD
         Fglov8BaUYXi+vpXK91oF8X16LUlxAin/PpgTF2whBJeWFiznibc+fYmoCWrJk73Fzvf
         AsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568654; x=1752173454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PaZvyCikUvPqtnjUjM92+A61XpmMjGb4Ba8q0a5FCxQ=;
        b=IBkShb/2XewZEAZnPRJSYDG+jY9MKe7mNy5LItefCL1lmV6ftw4M9zLzuciKeOCKJL
         3UEBZyV9T+G3IGJaIHyyf2gQrkGmzQNRLiCsxcKX0+7w/2wephb+or0ItBYdKkY8PAMR
         GG4bVoq7rrHMhqR3Tb8KoeiIG9EBLzjKyCTxmEgkJSa42/flLyeyYK/K+aGjzRK+rAHx
         trHnkDzN/Yf2/g1WzMmufZ6rAYenb+KS3n0LjUjNNTUjnYuPXU/xr676wtZbluJ8yWTR
         g1IpJHY7uHFhDGW0CNoh01JTLoYpBx9juKWcAhhpNyKNc6mECNJyLc+qNpINcfjyqQ82
         s9MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnlDjiT7msGQA1FvIwEWm95ptTjynGP2459C16fuoB+Cbc8PhciRRTbZgHkgV6C9nmlY53fW4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBAU3FZDQJO35DbJ0CWRJF6H9MDFIORuANyid/HAa78GGNt5Jg
	mJnBtSB9UARvnvyiHIhEojB6eSSPmak4TnUGR9+1/6giJc0HKDhF8fdr
X-Gm-Gg: ASbGncu7yT80TJOMKf2EbbZxa11t91hOkEbr9KBSAqm65OCfB6udOkNABIWjCt45k59
	HRO10mTsKDe3cEMiHQoCJex1vu89OqWTk86HQ/jh8vZF5DZKjiUTi8pugAIR7PRSb+xbk4lp+ly
	jQy5Qdm0EgQqQjgFl0swiQmBJlReXTo1xAlrhvzFYnjEvRV0UPLQ7cRFpM37Ze4+AjewQIxihZM
	R7gdzQX2GX5kCI1nYSmbo2keZOWWz0rczX+691Gr86/PACmqmp/xrCA1x+01dtWlENF4PDVoe2g
	Z6kdaaxrNtRBdNbp0d+fV/TPD4bLTxPPu9BvFqYKsQAxJfofvvifWoBFWlZ0VBmWezuxlYYnBAX
	UbfCG9Mwer/DEEg==
X-Google-Smtp-Source: AGHT+IG1W2DMSfl06LORBDysLa+UgwkOnJVfP99hi5suwjrNBfuyFXSpDfxUXAAn0IKIrMiIDsFKRg==
X-Received: by 2002:a05:6830:f8b:b0:73b:2c88:8ec3 with SMTP id 46e09a7af769-73c8c5d0bccmr3217610a34.27.1751568654018;
        Thu, 03 Jul 2025 11:50:54 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:53 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC V2 05/18] dev_dax_iomap: export dax_dev_get()
Date: Thu,  3 Jul 2025 13:50:19 -0500
Message-Id: <20250703185032.46568-6-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

famfs needs access to dev_dax_get()

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/super.c | 3 ++-
 include/linux/dax.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 48bab9b5f341..033fd841c2bb 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -452,7 +452,7 @@ static int dax_set(struct inode *inode, void *data)
 	return 0;
 }
 
-static struct dax_device *dax_dev_get(dev_t devt)
+struct dax_device *dax_dev_get(dev_t devt)
 {
 	struct dax_device *dax_dev;
 	struct inode *inode;
@@ -475,6 +475,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 
 	return dax_dev;
 }
+EXPORT_SYMBOL_GPL(dax_dev_get);
 
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 86bf5922f1b0..c7bf03535b52 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -55,6 +55,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 #if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
 int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
 struct dax_device *inode_dax(struct inode *inode);
+struct dax_device *dax_dev_get(dev_t devt);
 #endif
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
-- 
2.49.0

