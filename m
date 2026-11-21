Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795262725;
	b=3E+o+fmS95wTRipU9Lo9qQ3lV5scKDfkoMRV2CEB5MhqYaqJ0qndeSBtEbYFqzh4RdLH
	 7b2JeY300NdjZ1gCg0kAKuvBnhT/ynkWUQUmBP7p3tocf018dMFIM3Ioo/HQMqH8jtu24
	 kIicsCworrvi80eYKvUtFhL9lvCT1F1uJP+b3nSXonJKedJKQdY2/SMVJt+wtkk4K7cd1
	 ywT++LbIPUg9c0dtVGkdskUpTBig0ILinkpK/xr4BxhIv0kpwp4l9q4uzk4w7eGjwzLrN
	 Hrc9T0KCQ6Slv99151R0x33VrUmp1Pvfp0kcoFS58Z4dJg2NulpeXB5QiVEKhaoWNpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795262725;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GgVA1m9FFgPmu9ov9xNiU46KV5AN9vLfSCEf+vLxJ2A=;
	b=HueveC52JQfIwAdf00y5KTDafTpSL6S7ymIF2czluID2lH+td2L+5d7hddhbYOU5xrU0
	 u2HEOJlg6XGEFdxd7xQ3V40bEB+c/SAC4uy8ybUn5yNH4GBO4F5RzwZNucybJg3VA6SDf
	 n4hKDa2OtdorMghFshk8kQpvRh6Y6cUumx3csWFqWexzr4jsSIVXxOFvQ+4DKA6/HOPdy
	 vaxZ3YFgwl5y1JHqGEiO3h815wvajtgE1Q5l4yDbI+RUnQA/WJfVs0lKrRW0zJjg3ry41
	 vQLABfQ1QQ8FR3BdTXyGsium4UYU3DenAQHj3Qe/BWXlnWfJqfPPoBeDof6POc8m0XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="DgW82/TA";
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F97606A32C
	for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 12:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99F97606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DgW82/TA
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06e79e152so891380b3a.0
        for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 04:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795262725; x=1795867525; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GgVA1m9FFgPmu9ov9xNiU46KV5AN9vLfSCEf+vLxJ2A=;
        b=DgW82/TAH11qsWHKhmN4FNmLkkL/a2AFW2+Hn2kuXXvxs8Zjx9ptu9PhmcEJAkN5+j
         OuTMtFcYkU9RyA0L2/mORiB8e6poJabQoPS7hTHuqm4dnDwTv2tBaaY3eunzuSsCxH6g
         RvihCMZWZWIT1hsYVSG82EqdDY7L9m2WGFcYdsqewobTP3gVVgtuh/pPzC+3s4QrULvT
         qsCWSZPbw1m9GcLEv6VL96tLzq8WHJXZ5pytXwcBXkUVqNprWFv2XExwqHFdgjr+KqHT
         rj1Xe+euA+BN6cwbwXhJbXzP5bWXDyQRloCaTSuUxKsSQJ20kzaLKxsDCN65cBwDtAMp
         Sz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795262725; x=1795867525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GgVA1m9FFgPmu9ov9xNiU46KV5AN9vLfSCEf+vLxJ2A=;
        b=s/Z4H1pU9LPrCU53E1wpwIE2/txXt0xvO86ocs44PxJWyCMeuRaHRGxwGr7zshhH87
         NhZbCWAzjCvPzozZdkRFR6HSmELeD8vMgR7ZIUWsQrZj40WsO3kwKaCzSmaIozzRr9Hb
         o3OQkfcqy9Nw5/hYyJq7HuXLH4jHUgkITWEnj10LzZ447b71x31I+HnpF3jcMxqpU3hc
         fOr/+8oAZ9vk91Mx/MTdy2AUAO7YKaMM9vY3pEQk5uJSCB4HnW00T9//wR8zbTSOGkjV
         7qwlrs/dJk4bfP0E4s417N4vmBPtxKFYf/P5Gfk+tYiAZpVvlWM+uXD35/sbFJNlwCbo
         bQvA==
X-Gm-Message-State: APuU4Z96/EDkZiJ84d6ofgiV4OUXfCro36Ybs1CbM3heSDzmhHOHz7eD
	IgxELkdri3ehQSI70yExupi0DSd0/mNv3bb/jTZNgSE7fbkSMiENA2kKBU3NWQke
X-Gm-Gg: AZFdTZc5k3jk4bIlqq0uSgU53bhSgenQH8RqKLfbBN7igZRkCa6diXsDl1MxAqCWiMf
	sO93oPRDESOsWageO7r8uHPOUVltvn2eTSzTufR9/UqeD09aX5uN5VtvoHo0/QqnBdCBv7aIRQT
	vsv2pn+Snct+sz3qo75bK2obS26fjpSDWUF/IPdmL6RwE1b3tx9akjiHXFI50vcC7K26wOHMnqd
	LM9mf0yHOqvmRMP1CKt0bsMI8vHKbx8ni/5+EmKujbQrAqIiRYk0BIf1OH+iiFE514MadAZ4+3N
	vb2OqEgAr0zcQ7CQpbs85xuu3FqernVmFWaSVOf5Io/GXzsdSRDgK+H37fUjLPOlM25YTnARHXZ
	gnf4zFRuEelUUkjdzP4yVy4Gnk7oQnphgyoIYP6yCWGqzEj6T9ikJ3vT3+l33ihV37XQROAzFYu
	sotpkZh/VVjQ8zy1j1E5JITMbGiRSMJr7pR8XseOSYi4CndnAgpfd5Gm5Ok4N52cF73fHzTP8k0
	EJlzKpjCyszPMjxh+nUdAuOtppJ5RNqB5+ahyh0cR/oFyauybBHEAfsJDDK8j4JH2z1QGysBO39
	OSGhZJcvVAoKqOTw1ub0CKiiEYeW7vIAFLHtyu0dhZ0XzLmJ5IYWQbMLQCxoy+s5
X-Received: by 2002:a05:6a20:c992:b0:3e1:88d6:60e6 with SMTP id adf61e73a8af0-4014a27f154mr5369152637.10.1795262724938;
        Sat, 21 Nov 2026 04:05:24 -0800 (PST)
Received: from localhost.localdomain ([121.134.184.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8706844a0sm2857177b3a.1.2026.11.21.04.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:05:24 -0800 (PST)
From: Unsung Lee <unsung0317@gmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 1/3] test/cxl-update-firmware: Make wait_complete() honor its timeout
Date: Sat, 21 Nov 2026 21:05:04 +0900
Message-Id: <20261121120506.1562043-2-unsung0317@gmail.com>
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

wait_complete() either sleeps and continues or breaks out of the loop,
so the max_wait check after the if/else is never reached. A firmware
update that never completes makes the test hang instead of failing.

Check the timeout before sleeping.

With the timeout enforced, the 15 second limit in
test_nonblocking_update() leaves little margin: the 16 MiB upload there
takes 9-10 seconds against cxl_test in a QEMU guest with lockdep, and
10.1-10.2 seconds with KASAN. Raise it to 30 seconds, about three times
the measured time, which still catches a hang quickly.

Fixes: 813809ed318f ("test/cxl-update-firmware: add a unit test for firmware update")
Signed-off-by: Unsung Lee <unsung0317@gmail.com>
---
 test/cxl-update-firmware.sh | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
index f326868..100d15f 100755
--- a/test/cxl-update-firmware.sh
+++ b/test/cxl-update-firmware.sh
@@ -61,17 +61,15 @@ wait_complete()
 	while true; do
 		json="$("$CXL" list -m "$mem" -F)"
 		in_prog="$(jq -r '.[].firmware.fw_update_in_progress' <<< "$json")"
-		if [[ $in_prog == "true" ]]; then
-			sleep 1
-			waited="$((waited + 1))"
-			continue
-		else
+		if [[ $in_prog != "true" ]]; then
 			break
 		fi
 		if (( waited == max_wait )); then
 			echo "completion timeout for $mem"
 			err "$LINENO"
 		fi
+		sleep 1
+		waited="$((waited + 1))"
 	done
 }
 
@@ -149,7 +147,7 @@ test_nonblocking_update()
 	mem="$(find_memdevs 1)"
 	json=$(do_update_fw -F "$file" "$mem")
 	validate_fw_update_in_progress "$json"
-	wait_complete "$mem" 15
+	wait_complete "$mem" 30
 	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
 	check_sha "$mem" "$file"
 	rm "$file"
-- 
2.34.1

