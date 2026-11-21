Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795262731;
	b=RdETZYDRQzXZxnfBlhKVtgdgJjiNaYWxYzDTLVidrC1rc/hRkqLD0tANhqq5DJtedw3m
	 0L8aALfZ92fGqjao9gptkeN9hx593xSJWQuISS8oDMmI/tntmgL/S+kQlJ96/maDu7OFQ
	 RhjRYMRimsJMURuY5plv7ALDyN/Ed+URooJzjj4EkT4bT3MOVrwJ86aeF2e2Xt4aZ75N0
	 c45En2bLJZJrEUfgK6DMR5MJ7jNFYty0dF0Su5cLifP6/HGIWum4hlGAzeS/jWi3B00f7
	 Gl1mdgm+au6DZU+ZZR40BNC9P7sOw43xfGcxjoSXzNA2lW99eQiNUiG0ISMrY8axcaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795262731;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xQQHpRs7M9wztbVkihpFgoh4ndj5jkNLjAef2ynID3A=;
	b=KhQwAtsXH6l632Lm5COaegPPUKm5E/Rr2BSZ+j08Ozbo8xM6VKYXDEjZ3KmJoTawMK7V
	 niu2GkC+JqnPchGata/79HWqRXAaZoFY7259orGX3OnreRfpzwxtGA3SsLh4VRUigSugk
	 mo6Q89htEGjFuqp8+1xEUwZLgFkWY8Di2GjHEX/GLeo8PQnPDWEcIzQ5/RPjCDvOaeDbS
	 nTbaxKju/OHffW4Ljq4/MZFTm0Gl2AHPQqbQUKuLnQ+ANlmrQl58Ep/DC5XtKKWet+vRN
	 IieW4REaBkiCZim9Tb9sozzVELlAx6RJEoYJXrGdlMPqqZzBaLFU08LljG8/nGw+9WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jZxHrRaQ;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FC9606A32A
	for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 12:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20FC9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jZxHrRaQ
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so1369953b3a.0
        for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 04:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795262731; x=1795867531; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xQQHpRs7M9wztbVkihpFgoh4ndj5jkNLjAef2ynID3A=;
        b=jZxHrRaQw2WvSA4TaPEP0uFe7c8mDAxOKbzoD6LuOXql44br3ppEGCcW1wquTta6TQ
         kDR21/3DOSgXVyK7cSdJrOpBXwsSZR5HfDK+Db/fZfGXLdI0+T1jaf6YJV98QRWEs86T
         32MNCusqRhC007X5iDAYdl01p8eIVeem9ni6a0cD1qIAnYcfTUEdrQgCWkxDaLQvDvyL
         R/r0bqN99lJZQ4ua7SlcQBJSlUKK0hfd6ZNihznccnPYQLU5S4uG/5lIc57YQwI7J/AM
         2cCSo3xQ0xhvlrlvfLWXOdpufwLSKBl0J/deTiGUBJwVZqhhJPbYj/aOAmMubDDmkPFT
         QpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795262731; x=1795867531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xQQHpRs7M9wztbVkihpFgoh4ndj5jkNLjAef2ynID3A=;
        b=t2iLtZCp3KaiClzb8xyY3C0KS7Xw9kD86vxL5X765p+L0YyYQumx456P+52QCYR1Ug
         XhL8U8hBpgeIpkS9LfygN6kD6TCQxMs80Txt1vmVx7NxBqM3zYk57npxgUENIImH62fc
         RXe7gY93IS1xNUTzxF/Y252J7en0wTlTnpvQ1l2n4v4XtG+ml4ONyHUE++Vcui0tsFeq
         dCyeNhAaGCIdisupvdkedtOzt33KabFBHy80M9t335xMOjbzxvS8NFJwNoGJ8UMmwLMn
         7XIDWCmAtorkeoRI1pdKlvEpiBadUJo4ZLeqdfWuedZeiv+lsSm79/GDJhg1Y00xsMw6
         VmHg==
X-Gm-Message-State: APuU4Z9M0U9MJ4cRQ52I9iM8HGF7PzkahO06F12L87FzQWJU1ByiAgrM
	wKTBvIYynY/s+iwEBcqRd+I4pBQEZ1Wli6nqaQJco7o3Fi2Qmrn/jZUGTS8SQ21e
X-Gm-Gg: AZFdTZfkcCmyP4qUr9rDg+bInpjvwr4xMUASIl6MvbvOYve00DreOTSIhi7yIOnSHSo
	kY4sNdHpWOzNetRxqaTI5SInAfiyk9BtPczZ8+sGKt3prp8WdmnXP17Nm9wdBw/7rXiBisxHqog
	QfH/2esomnbjEampszfjRnjEPDFZ8vacM4CKe/BfmyGrdy0JHCX1rV4pLkG8ASWQjolNcO6Gwq1
	0Hm9+q2yHRInzBq0rlvGZilMS+Cmy5kE0ustuy/prPtl4yH+MFQprJxsdwM19Zi+uN0h3zi0Df5
	Ug37wBC1DVsXZ1DGtTaZ+qPdNBPobRBm9bbnl29FJYlhpzN8WixMwynd/yr6zVM1AEeWYlX5Qeu
	FSZ95UDz/zKxdR21iysVCrtpgmihZi0GPM6harB6SMEDR3cqCz+x5la5N9W7cJN/R03EhrTdoc6
	F/MXkerYVcYO8k+zFWoKMerfT0CkuKDcf97OOKn82fcYzlNw1ntZlQg19PmQUh6mK4bnwXaj4mg
	ccXDgXnIhimzfqxf6DdRZKDEAMcwD9cAJq1wVdtoK0HQ//IANSJcYxfLL33l9Uf48uHyEeMBkcF
	dLbzRwMObBNbHXAjgHIkxwn01QvI336GbxRiI5g1izRCAsyMbAxp7qxkJ6b1AXsw
X-Received: by 2002:a05:6a21:398b:b0:3fa:e66a:fc52 with SMTP id adf61e73a8af0-4014bc5377fmr6568760637.26.1795262730530;
        Sat, 21 Nov 2026 04:05:30 -0800 (PST)
Received: from localhost.localdomain ([121.134.184.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8706844a0sm2857177b3a.1.2026.11.21.04.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:05:30 -0800 (PST)
From: Unsung Lee <unsung0317@gmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 3/3] cxl/memdev: Fail update-firmware --wait when the upload did not complete
Date: Sat, 21 Nov 2026 21:05:06 +0900
Message-Id: <20261121120506.1562043-4-unsung0317@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261121120506.1562043-1-unsung0317@gmail.com>
References: <20261121120506.1562043-1-unsung0317@gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'cxl update-firmware -F <file> --wait' returns 0 even when the upload
was cancelled or failed, so a script cannot tell a failed update from a
successful one.

When an upload fails or is cancelled before all data is written, the
kernel firmware upload core leaves remaining_size non-zero until the
next upload starts (fw_upload_main() in
drivers/base/firmware_loader/sysfs_upload.c). After waiting, report an
error if remaining_size is still non-zero. This covers a ->prepare()
failure, where remaining_size is the full image size, and a failure or
cancel during the transfer. A failure after the transfer, in the
programming step, still leaves remaining_size at 0 and is not detected;
that would need the loader 'error' attribute, which libcxl does not
read today.

Only check an upload started by the same command. With --wait alone the
value may be left over from an earlier upload, and the command keeps
returning 0 as before.

Add a test that cancels a blocking update and expects it to fail.

Signed-off-by: Unsung Lee <unsung0317@gmail.com>
---
 Documentation/cxl/cxl-update-firmware.txt |  5 +++++
 cxl/memdev.c                              | 12 ++++++++++
 test/cxl-update-firmware.sh               | 27 +++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/Documentation/cxl/cxl-update-firmware.txt b/Documentation/cxl/cxl-update-firmware.txt
index b7342aa..5af6520 100644
--- a/Documentation/cxl/cxl-update-firmware.txt
+++ b/Documentation/cxl/cxl-update-firmware.txt
@@ -76,6 +76,11 @@ include::bus-option.txt[]
 	it will initiate a wait on any current in-progress firmware
 	updates, and then return.
 
+	With a firmware-file, the command fails if the upload ends
+	before all of the firmware image was written to the device,
+	for example because it was cancelled or the device could not
+	start the transfer.
+
 include::verbose-option.txt[]
 
 include::../copyright.txt[]
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 7f0d021..fe54258 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -798,6 +798,18 @@ static int action_update_fw(struct cxl_memdev *memdev,
 	if (param.wait) {
 		while (cxl_memdev_fw_update_in_progress(memdev))
 			sleep(1);
+		/*
+		 * The kernel leaves remaining_size non-zero when an upload
+		 * fails or is cancelled before all data is written. Only check
+		 * an upload started here, a stale value may be from an earlier
+		 * one.
+		 */
+		if (param.fw_file && !rc &&
+		    cxl_memdev_fw_update_get_remaining(memdev) > 0) {
+			log_err(&ml, "%s: firmware update did not complete\n",
+				devname);
+			rc = -EIO;
+		}
 	}
 
 	flags = UTIL_JSON_FIRMWARE;
diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
index e93bb00..d172994 100755
--- a/test/cxl-update-firmware.sh
+++ b/test/cxl-update-firmware.sh
@@ -190,10 +190,37 @@ test_cancel()
 	rm "$file"
 }
 
+test_cancel_blocking()
+{
+	file="$(mk_fw_file 16)"
+	mem="$(find_memdevs 1)"
+	timeout 30 "$CXL" update-firmware -b "$CXL_TEST_BUS" -F "$file" --wait "$mem" &
+	pid=$!
+	waited=0
+	while [[ "$("$CXL" list -m "$mem" -F |
+		   jq -r '.[].firmware.fw_update_in_progress')" != "true" ]]; do
+		if (( waited == 10 )); then
+			err "$LINENO"
+		fi
+		sleep 1
+		waited="$((waited + 1))"
+	done
+	do_update_fw --cancel "$mem"
+	# the cancelled -F --wait must return, and must fail
+	wait_rc=0
+	wait "$pid" || wait_rc="$?"
+	if (( wait_rc == 0 || wait_rc == 124 )); then
+		err "$LINENO"
+	fi
+	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
+	rm "$file"
+}
+
 test_blocking_update
 test_nonblocking_update
 test_multiple_memdev
 test_cancel
+test_cancel_blocking
 
 check_dmesg "$LINENO"
 modprobe -r cxl_test
-- 
2.34.1

