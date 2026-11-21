Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795262729;
	b=kiG3UO4w0oCfAkJJJAgY6W03othvcRKgzgvJBAUoh+CTPjb5EG/zaDfTYw+wuVspy0Ez
	 S3ZPxQjfC8WMRwsOt4yDO5lObGM7EhbKEJB4coQyvUDIp2XZ79d5FusHp40dWA3f4U/oI
	 NrYJjwRUUFdzURlo66sUZhlh4GFT30o9JmWhVeXgdmQZRz0APg2Q+7fANJP+3Nr17CFhw
	 nhInOTdHFG3cwTsjvU1pOMeMXfzGJZDdYdRMw+wkdI9h++kln7qInUxNS+UAl7yepPF3A
	 kDo+CkJbDstHKb1TgxD19DbimrxXLc5kD3GvKOE6rWy/tIS3OnZqtQABW/ksbnoIM1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795262729;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sJLz5x6oV0KVeJ9JGZQ4MN1uop6g+t3PihmjDeELpBM=;
	b=0mvi1ts4r7TxUBttiIjOIcQL/6ZpLNdmHH+x2rLEuavRgemuNOl3F8Oj06ZhVtbFYpH7
	 1pZ/2ZZ0CQwlYDlrYbNUCWxwlRqlLgpsckKfAOv7/X/K0xymLoBst4P4Tquap54Lq+SaS
	 +70ugzfVkZrWkQKvHNO8rDqoVHc1KfK1Lpspya0IDQOspA92DuOanK82J/y54FXYTXKhR
	 cP0ohqpthYVHLbCczbnYh2ib5qtYPCv/io51aUzH6wITDn7gxGmEk6XzJb+V0e2v8ft1H
	 qo5Slx2VVlugZfvv+Ytfyw1SVN5wHSYw40lvwPoZ1ExZlYlEZ1V/oSuyBtvMkFsJq7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z9cP6ttx;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB64606A32A
	for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 12:05:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCB64606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z9cP6ttx
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so1545051b3a.0
        for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 04:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795262728; x=1795867528; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sJLz5x6oV0KVeJ9JGZQ4MN1uop6g+t3PihmjDeELpBM=;
        b=z9cP6ttx1U+JqXm6rITGeiOAny61qafc/VLDZiQthP/39BxtfsX0X49gQho0mafRTI
         qBqUNpCma1T7j66gpFlwq54J/kLkVcs8P+SOHz4BogR2AMziSdcStT8l4/qU61bbOaZG
         6DxtWOKXpLQg6FyB+1GljMTZDGnapBfD9a5LAM0MAJLqf73DPuIUb1NHkl3oPpMANV4R
         n54Mu4uGlMgiCevyqjPzQNrlT3HpOpY75+3bROJ8L7yisZKQ79Qw9DA+/uucbQXN8MRa
         mh5wTCKjkoAoUhtzXNWyq97wxrZPPh0Sj6p8eocREvPSthRBk6jj4kgPfJUwlgvds+K+
         T3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795262728; x=1795867528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sJLz5x6oV0KVeJ9JGZQ4MN1uop6g+t3PihmjDeELpBM=;
        b=DgsIAfGPiSDcHFePneCG1PCe+WH7yLZ561+0q+mDUGxbbW4BWtmW1K51n+QNGZVZYo
         Uao6RhoZ52kSJ+S90fB3+/ZgdVEDz9vtpLxGkhvw22KZyqzNXkJ9euSFq18eBCoGYyJf
         ME7UfeeNQmcPVBdFI6kqVGs5jMFfjFF1Fog2TpckdMTx6IZcAm5jK8ipZ7R263X5YzF0
         OLbHsghkyxU/292Xz0H++NcLu7OQGKzK7zLhpD/ouQSvYKciLhr0asMP/JK3m33d9P3P
         OffGgv4GC8YrKsBTqJnfMJ+XO99oFRHxuaoO2YkTCX+xNvzntEW6dFbGZkmd85WZsl71
         JKtQ==
X-Gm-Message-State: APuU4Z/xdIR37QfbELFdMbaRjC8JOlKPNNRyNDBDBjY80uVSHh6T8qrZ
	W6rDAudJG57qIvNINNnFcVwlx25Pb74r0gFK3D2zuqLCLEatHDThuLfujerXtdog
X-Gm-Gg: AZFdTZdhjBuKLcDIYwnh70Lv28DwwrLrfHGOnFiQXGNUbP1A37Q2P4G23equrGLfmX3
	9jslb4gTzepW3F9S3zZqJIvPT2oOnbUzmPutJ1XTFNyDYDZLJ4d2MZGgln8WBMjde8ZOJZxU8+/
	iw8/3YEJaROmSqCxoQA53VQjUQSAdoPGlxsQ5bAqvKGxOnZlLF6RGN1SOD0d/fmEGoLcZ08pcWY
	f87UAkm85MXtrU5FNI8pZoTN2xjQfNyiARm3bThhHse4yXH2rR6sJAQJ6SGzKlG3iuTcSfN3vGx
	kWyoEPtTJ6MQ+Sd5Ka1EHkCYetWH5FNgU+RgpsQ15ful7MaJDOk80WF8QOaLR/dPVZZ/h/gZXAa
	QXGuVQ5gTAzfFzM2KkB8gSAcxhfi5QR7nZo/A7luxbIKwdf4dZTisfmM/G4jtIk99NVOPngNNHV
	EDm7HuxdI5vW9q1gqT9A8HKcPsBgpg/0+oNkH0jTVLd6jv1GfRMJNjqFlssPLwOQCs/Mod2GDR2
	0xsfvkfYm9tXwjoC5WCT9IFyGMX6BgFZkptRIzTKgDUa9gg4wk4OhMKrrfiXM0sRpFf9dr49AvC
	cj8a2iuegrHeRGQyWeGSpRD26hi8q5mpbg6buGs+R3k=
X-Received: by 2002:a05:6a00:298a:b0:886:31d3:51a2 with SMTP id d2e1a72fcca58-8c87ce31d2dmr5370445b3a.39.1795262728064;
        Sat, 21 Nov 2026 04:05:28 -0800 (PST)
Received: from localhost.localdomain ([121.134.184.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8706844a0sm2857177b3a.1.2026.11.21.04.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:05:27 -0800 (PST)
From: Unsung Lee <unsung0317@gmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/3] cxl/memdev: Stop waiting on remaining_size in update-firmware --wait
Date: Sat, 21 Nov 2026 21:05:05 +0900
Message-Id: <20261121120506.1562043-3-unsung0317@gmail.com>
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

'cxl update-firmware --wait' polls until the firmware loader status is
idle and remaining_size is 0. The kernel firmware upload core leaves
remaining_size unmodified when an upload fails or is cancelled, "to
provide additional information on errors" (fw_upload_main() in
drivers/base/firmware_loader/sysfs_upload.c). After a failed or
cancelled upload, status returns to idle while remaining_size stays
non-zero until the next upload starts, so the loop never exits.

This is easy to hit: start an upload, cancel it with
'cxl update-firmware --cancel' while it is still transferring, then run
'cxl update-firmware --wait'. The same happens after a ->prepare()
failure, where remaining_size is still the full image size, and with a
plain '--wait' on a memdev whose previous upload failed.

Checking remaining_size is not needed to cover the start of an upload
either. Writing 0 to 'loading' calls fw_upload_start(), which sets the
status to receiving before the write returns, so the first poll after
cxl_memdev_update_fw() cannot see a stale idle status.

Wait on the status only, and extend the cancel test to run --wait after
the cancel.

Fixes: 64ad46b4a147 ("cxl: add an update-firmware command")
Signed-off-by: Unsung Lee <unsung0317@gmail.com>
---
 cxl/memdev.c                | 3 +--
 test/cxl-update-firmware.sh | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d15..7f0d021 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -796,8 +796,7 @@ static int action_update_fw(struct cxl_memdev *memdev,
 	}
 
 	if (param.wait) {
-		while (cxl_memdev_fw_update_in_progress(memdev) ||
-		       cxl_memdev_fw_update_get_remaining(memdev) > 0)
+		while (cxl_memdev_fw_update_in_progress(memdev))
 			sleep(1);
 	}
 
diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
index 100d15f..e93bb00 100755
--- a/test/cxl-update-firmware.sh
+++ b/test/cxl-update-firmware.sh
@@ -181,6 +181,11 @@ test_cancel()
 	# cancellation is asynchronous, and the result looks the same as idle
 	wait_complete "$mem" 15
 	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
+	# A cancel during the transfer leaves remaining_size non-zero,
+	# --wait must still return.
+	json="$(timeout 15 "$CXL" update-firmware -b "$CXL_TEST_BUS" --wait "$mem")" ||
+		err "$LINENO"
+	validate_fw_update_idle "$json"
 	# no need to check_sha
 	rm "$file"
 }
-- 
2.34.1

