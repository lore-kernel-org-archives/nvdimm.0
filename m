Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC3186651
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410318; cv=none; b=CNuZE3B6ugXxZTmCdRlOdBzA1qkflY1Jby43y+sxFLuOcJbKzGUl2Fvngm3PZ0YeArW5yDjfEIfjZX2pP+bYuDEOtt4Me16oqX9K761ZLKBsLIgSlN2DW3b+M3VKRILNquzVmXKj7EqeE6yTDkL604iWAptMxgMyPanwuSrm7Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410318; c=relaxed/simple;
	bh=soONSsHFI6nzOHKUp35TcQ0GKddlcVxDmE7JFRha/Gg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KkLM6XNRA5tZ4pHvAj52RW7mXCQe4lZdzwwFm3Gl6WdMFHzu5ZnQNWulHQjjG7FD/sPE14gk6Mos8NFAyDTVRluXwBPimQWN4S0ht2O9GSXomHt+K1ZNko6SK7zx77GeNI5FC0TeK8o81NZQIvDfaJqrXjK3qI4CjSPHED0RA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F3yAbXJY; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3yAbXJY"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6ee1b203f30so1095625a34.0
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410315; x=1715015115; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eRZMXpVDaupswF2EGFq0CRj0FomMbu4maf2unw0x+4s=;
        b=F3yAbXJYYtiEqgmc6prd65pf0ZG4kmXk/jALFPUQfO/Vci4o/iv8gKGrN8IsKKVo/5
         gUZkPCw3SxcL6ezUKbB+iZtEBPiVktoquwQ9/A1OsFOsCU6Ad1ivrVomt79A9YHqKjs+
         ek1lo1E01PdlWyEIGfgx7UlACjK98DVrPtJmmWyZKNfWsJ4omiYHoSztKzfUZ44EDm5I
         1gLmeSoJWgtQdwxvjNP7SvQWCtKkQSlVy5M8uHIHIfcPW4qJ9jSdnDzCk6R87MUFNr6K
         3EgC8vR7dFcS4uJaPN7uxnDdfumm4VZV6Wg+0uL2Yc15O0Pxk8yUojh2MxW1Tv1oBCgy
         uWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410315; x=1715015115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eRZMXpVDaupswF2EGFq0CRj0FomMbu4maf2unw0x+4s=;
        b=EaZdkcDC3lNr01p+xivbTRk9qWILx42rGOY41cktfnAf97iylQgecXYW/npQiYLNoW
         SqDWfSWk8w4S2CTESgqPbHynoMhmr1LZ39/BYgzd+dUAPWgZO8fXHVHrQ3qvvwDsODjt
         aFC/WfxkeN9z2xlG1P541uWBLRFAEFRPUoke81WnpJkEj3o0Y0t8LPUqggjENGb989UK
         0j6WhbAOmHoUIecKHsoS8tp9d4plwNGghCc7Fk1/6MQ8vP1ECtphdCKJuJdidbUObN6J
         c5rzNc5myocBXP5/1oB1SSnNpt/wgWz/XAN0/3M1cxzmYmad1IKTQbsyaVOExRSLxEli
         yXvA==
X-Forwarded-Encrypted: i=1; AJvYcCUdNaANbMwEw4VhPnuxHsanwghhFhIhu0+mQdpPLHRRgNuSAikiI0sKG0BepvhYolxEKBriGi4FO890UIIgLRAOPgu7VfeC
X-Gm-Message-State: AOJu0YxWvmMtkcj3GE/CTXwjo8Y8/QRBp6Upq0gpGdjnvAkAZtMaVRh6
	8pDDlVAP5YX04jvrGOFPzAJWIi+zAmwApdMQ7IImeBLyUOu5Zyvt
X-Google-Smtp-Source: AGHT+IFAZMCprMAfngbGfmfnfc0KD83EThJP15yBR4/UvGbdxcZfQLPaHwO+y+izxvLX28mjpzQ3QA==
X-Received: by 2002:a05:6830:1516:b0:6ee:3710:231c with SMTP id k22-20020a056830151600b006ee3710231cmr3205587otp.2.1714410315062;
        Mon, 29 Apr 2024 10:05:15 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.05.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:05:14 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John Groves <jgroves@micron.com>,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	John Groves <john@groves.net>
Subject: [RFC PATCH v2 07/12] famfs prep: Add fs/super.c:kill_char_super()
Date: Mon, 29 Apr 2024 12:04:23 -0500
Message-Id: <a702d42c922737c4f8278617db69ce2b6d813c5f.1714409084.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <cover.1714409084.git.john@groves.net>
References: <cover.1714409084.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Famfs needs a slightly different kill_super variant than already existed.
Putting it local to famfs would require exporting d_genocide(); this
seemed a bit cleaner.

Signed-off-by: John Groves <john@groves.net>
---
 fs/super.c         | 9 +++++++++
 include/linux/fs.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 69ce6c600968..cd276d30b522 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1236,6 +1236,15 @@ void kill_litter_super(struct super_block *sb)
 }
 EXPORT_SYMBOL(kill_litter_super);
 
+void kill_char_super(struct super_block *sb)
+{
+	if (sb->s_root)
+		d_genocide(sb->s_root);
+	generic_shutdown_super(sb);
+	kill_super_notify(sb);
+}
+EXPORT_SYMBOL(kill_char_super);
+
 int set_anon_super_fc(struct super_block *sb, struct fs_context *fc)
 {
 	return set_anon_super(sb, NULL);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8dfd53b52744..cc586f30397d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2511,6 +2511,7 @@ void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
 void kill_anon_super(struct super_block *sb);
 void kill_litter_super(struct super_block *sb);
+void kill_char_super(struct super_block *sb);
 void deactivate_super(struct super_block *sb);
 void deactivate_locked_super(struct super_block *sb);
 int set_anon_super(struct super_block *s, void *data);
-- 
2.43.0

