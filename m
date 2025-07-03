Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF22F365B
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568695; cv=none; b=LwXRyH/pzDdo4Rll+06tC9aXCbFLd6ySZoB/hw+ZqjKrkJgrXJtox1oEbMRBW//M0iU3oeU9LqdseyIrE3W4EoXye7tWYPAE/UFQ3x6rBgQuBYZC2Y+I/R+MIEUM/iitMoDcUTgRsIZqnYl/zGMwY81N8sx3iF90NwVhnwPynOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568695; c=relaxed/simple;
	bh=PqmaxnJIHXHdpAtoc4Brn2JoOI6Zdfs/rpGuWzqN4FY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fsf5VreMJZj2RLbS0Cb/oPjcieTO+Bzokw90MB8lSgwgoOyNLL47+IEyCu6D8KAGoZ712cuCt1/2F+vIApAHFse+ZvFUSYRRzai71QY5BiEe7INjfMQ+KA3MTQSAQGPzmhJWBNS2vQCwBO7hvmhWn2eSJbKXr/FKheNzP1iKdKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngst9Fax; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngst9Fax"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-40a6692b75cso219502b6e.1
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568693; x=1752173493; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOOgV+Jpk1CRsXiqsiDMUbyUGi7OO3TH0ZkMJhZELeU=;
        b=ngst9FaxqG4+KiFgYsFXWAqdcgExHsu6RjFd4P5/Dp5HJh6h6LpZTPWyX7G19PCTgM
         Lrz4ysQSJLLletWGUDq4CQPsadpQkaF3G7TDcgTkgsoAbbRV8vO7cPOsnNvWDj906Fl5
         bkS4R6WooDcIiyctgh3gMKiTCNdMXIm3v6bSPkGFL4mazJ3jT7cnUsL2tJ3bQ1+h08Wv
         kOR7KxqC7EtiAZZf8+h5e9GfSO9OVZeS7Uwgihs5d07osjQMfDHk0f+TJYXfDCpfZGG9
         GG7zxs/tSqAEU5p3QKbRr7cu05bH8Quy6q9W7s50oHFB7B71yM4uN7HPslrkpRv11Dmw
         aT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568693; x=1752173493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JOOgV+Jpk1CRsXiqsiDMUbyUGi7OO3TH0ZkMJhZELeU=;
        b=pPpH0Epra3OmS1jtxbIlZYOgwjAxXz95Rb98b7ROt06g/TBNonLD7Z95MBcRJQe4lC
         b8BRwnNJ+PLzeEFjD1zsnMxq+NfwLnvLlxjEbVrGEaKieNSlAaIPqqiLv7uvnI2LZMZL
         ncobhMzBZw/WR6b1usxZIVyResCQIDnW2/dZ299ECjGicTBGyBvQhIGeOrCrX/qbfne+
         u149wMuL/Uv/vbFrNnMa6+H9TKf5dhBXE0o2yYE5+jhsQHw5rrXncpiPytMDv+4S5IDx
         7lz1az6TWMLeiL4pc36F5LuzkBciFROTpVmt9WAhcNiJmTBdubzxej+ytL2xqd8BLwNM
         /STQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1wWcL5Xxwgn8xakVEy4LN3K3CuI2I8tbzjyWIp1m8aVZ5JHZ7BOR7WNCdys88k229rRl9QLs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWS7xahVF/T+de+Gxlq2ES8dm9b0TZ/HxSVvsZLGOHRLucdKAS
	xQmPNn+LoiwUqZq5Kg54w231QErQXqm7/JoS/jIWPoiwG1mgInl+hOtN
X-Gm-Gg: ASbGncsBbcfm/bL0/Bb+481EjoBYp3Kh4NsAs4EntZjAmaB0/8fOtegtCpnODmvwHGw
	C/ZPpkDybZOiHoG6/TCHOaa3GTgE2RwJS5s4SGsC0u5WonV47gdfF9mOF42i9mEkLVtbdhCW/dA
	kqi9IWlZMV2moBscm08wRurbZuY4Hf9eZUSClf6SM7pHt/W3oSN8AYT03k12KP8YOgtk+Y8kCBx
	AqhklSdvBpN/98UnN5V0pIl7Mp0PpnDMTJWHRDp9J+NVZS7YmYUSJr9d4nPrHXR4iY6PC/gWOYH
	H3sbwUQt47n4gl/z8dS4+PNsb8RLOqJfBbL3jXjEEBn/LOBOlBd8Q2ziGJNWTLa4oIpHuk4Thxr
	baofVZnVLm29oaA==
X-Google-Smtp-Source: AGHT+IF9Qqe/sVn4WtiU4VKCMm5wn96/NUIAh0VWVYCM001PD+1WVs4eZFRWpr4uPXB+DulmACrV7Q==
X-Received: by 2002:a05:6808:1887:b0:3fa:82f6:f74d with SMTP id 5614622812f47-40b88e07fa0mr6745164b6e.23.1751568692616;
        Thu, 03 Jul 2025 11:51:32 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:31 -0700 (PDT)
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
Subject: [RFC V2 16/18] famfs_fuse: Add holder_operations for dax notify_failure()
Date: Thu,  3 Jul 2025 13:50:30 -0500
Message-Id: <20250703185032.46568-17-john@groves.net>
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

If we get a notify_failure() call on a daxdev, set its error flag and
prevent further access to that device.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index 1973eb10b60b..62c01d5b9d78 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -20,6 +20,26 @@
 #include "famfs_kfmap.h"
 #include "fuse_i.h"
 
+static void famfs_set_daxdev_err(
+	struct fuse_conn *fc, struct dax_device *dax_devp);
+
+static int
+famfs_dax_notify_failure(struct dax_device *dax_devp, u64 offset,
+			u64 len, int mf_flags)
+{
+	struct fuse_conn *fc = dax_holder(dax_devp);
+
+	famfs_set_daxdev_err(fc, dax_devp);
+
+	return 0;
+}
+
+static const struct dax_holder_operations famfs_fuse_dax_holder_ops = {
+	.notify_failure		= famfs_dax_notify_failure,
+};
+
+/*****************************************************************************/
+
 /*
  * famfs_teardown()
  *
@@ -164,6 +184,15 @@ famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)
 		goto out;
 	}
 
+	err = fs_dax_get(daxdev->devp, fc, &famfs_fuse_dax_holder_ops);
+	if (err) {
+		up_write(&fc->famfs_devlist_sem);
+		pr_err("%s: fs_dax_get(%lld) failed\n",
+		       __func__, (u64)daxdev->devno);
+		err = -EBUSY;
+		goto out;
+	}
+
 	daxdev->name = kstrdup(daxdev_out.name, GFP_KERNEL);
 	wmb(); /* all daxdev fields must be visible before marking it valid */
 	daxdev->valid = 1;
@@ -243,6 +272,38 @@ famfs_update_daxdev_table(
 	return 0;
 }
 
+static void
+famfs_set_daxdev_err(
+	struct fuse_conn *fc,
+	struct dax_device *dax_devp)
+{
+	int i;
+
+	/* Gotta search the list by dax_devp;
+	 * read lock because we're not adding or removing daxdev entries
+	 */
+	down_read(&fc->famfs_devlist_sem);
+	for (i = 0; i < fc->dax_devlist->nslots; i++) {
+		if (fc->dax_devlist->devlist[i].valid) {
+			struct famfs_daxdev *dd = &fc->dax_devlist->devlist[i];
+
+			if (dd->devp != dax_devp)
+				continue;
+
+			dd->error = true;
+			up_read(&fc->famfs_devlist_sem);
+
+			pr_err("%s: memory error on daxdev %s (%d)\n",
+			       __func__, dd->name, i);
+			goto done;
+		}
+	}
+	up_read(&fc->famfs_devlist_sem);
+	pr_err("%s: memory err on unrecognized daxdev\n", __func__);
+
+done:
+}
+
 /***************************************************************************/
 
 void
@@ -631,6 +692,7 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 
 		/* Is the data is in this striped extent? */
 		if (local_offset < ext_size) {
+			struct famfs_daxdev *dd;
 			u64 chunk_num       = local_offset / chunk_size;
 			u64 chunk_offset    = local_offset % chunk_size;
 			u64 stripe_num      = chunk_num / nstrips;
@@ -640,9 +702,11 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 			u64 strip_dax_ofs = fei->ie_strips[strip_num].ext_offset;
 			u64 strip_devidx = fei->ie_strips[strip_num].dev_index;
 
-			if (!fc->dax_devlist->devlist[strip_devidx].valid) {
-				pr_err("%s: daxdev=%lld invalid\n", __func__,
-					strip_devidx);
+			dd = &fc->dax_devlist->devlist[strip_devidx];
+			if (!dd->valid || dd->error) {
+				pr_err("%s: daxdev=%lld %s\n", __func__,
+				       strip_devidx,
+				       dd->valid ? "error" : "invalid");
 				goto err_out;
 			}
 			iomap->addr    = strip_dax_ofs + strip_offset;
-- 
2.49.0

