Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896912;
	b=k8vSoLhv0ywyE/mNkkO5LqvLkEZcnHzIrJDQpXTHiyIozn6KVLlpLRDFEjDw2kMwRdGN
	 O4ZLkgWAlkL8j50PoTeuiN81TJfYkcIU46S8u5fR9ski6jhvAO9f0f/t3DGZnh2lNEBYA
	 kyjEPJQN1LfZZeDbK6JhvClOZo5KqwzNfQ+s35sjCFTn9EaSs8t2YvC8djtciLCvUGxc2
	 LaCBnDDBp4xsGDu7jqJ3Y7sKD/Op40FMlzWDSiTV0XEE/Sr7+G/tX69XSXBYG+BtVGjZK
	 P2FHCDLcwQQM5RnvkvXWLhQtRcLlutv9EEtNw9FF48BBSuczlS8D1deimhesHNLy3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896912;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1h+mNsm4d6SsdlXCt/tdo1XAATCvtA2LcsNfY9aNvYQ=;
	b=pZ3+8SW4L+enpEKG6ltVs5Zgygm/O2S7J+qNVJl0QolGdfseMX9aL1mjbCVMuRYcBuF4
	 OBXu+KiWAf+rph6LiQvKTeRRjHaVmEpXgUFpW8Jdlqiuj4bDrDUIDjESFW1Gfdbl0ENsL
	 KS9VXkLlo9HUv/3zWRzmHHJTiDr1SCl8wnGERJp282+1QKbQwfmMRxEi0XtPKIvPAJYde
	 hyIWGBjhrktyHso2krxEqcyn4Uc4QY2viYdBO6UXt/I513Y/h721EFd8CMQqeGsmrKESR
	 6ZPgoeSgYoxMQur+GbwgvM7dRaRNlWTCRMvQIBZDbetHthYuw+6F1xVMoZ3rzyHIFTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0NFzGmWv;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CADC606A333
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 06:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CADC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0NFzGmWv
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b1535be329so3154360a91.3
        for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 22:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794896911; x=1795501711; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1h+mNsm4d6SsdlXCt/tdo1XAATCvtA2LcsNfY9aNvYQ=;
        b=0NFzGmWv+mvUrbuLafDKBpFQMQLT94Ib/VeOuabpWhoslgqLsL5nN0utITqVXjswnQ
         9iEvel0sH38RAn+++ECYQlkYAbSzk5iddxqkDHBRAjg5f//fWkLeKgStMCRnS0V2uisD
         +YsJ8l1FpbFHfTSq405h1QTGRHwOj1W80/Q9HNbLjrVytCpk9PL5upgLP7T4naXAP9nt
         /B9Dt9277oN91SuMARnIEWcikdmiBavA/ZNHGswG7Z1zXW0srCNOR3RaIXkjl1hYXBE/
         c8PSsRDInc5vSmJ6bbbtWFFPK0rqT/3ZTc9Vi/fZkV8CgeNST8mNShc106UdLpjncTvi
         C/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794896911; x=1795501711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1h+mNsm4d6SsdlXCt/tdo1XAATCvtA2LcsNfY9aNvYQ=;
        b=IvS7yorHJFBwEGzRgKYvS8AnDoEzZ1DQSHqsTjn71Orj0SvKFbSgFxYw7oHltcX5Q9
         OK92hcmEOl8JdOEohQFjtX8wtRmZ/wMpHHqhTwERtQKgfwTu8kkXzU/SwnQeIqRWeG0i
         JuEDxJ0NZupjNqUh/MfpvgNQe6Z8Y0gUF463A7fzmjnIT9qF0zZTyZZJWGf1mtbE4LpI
         UYuWoAHl4LDp8go8dZz+qOTybWEsfuNXOMTLgsOrC/4JzMTGqJrMIzEGQS7b8ivD27jk
         w6PeXK4G50TtqMqqIyurGFQEBc3m8C8dz4UbdPCI1Ut5R1T8ogN3T7TRa1kz8J8FVnqC
         OzPA==
X-Gm-Message-State: APuU4Z+TLr30bSkt890sQD7pRs0UzO5xNCtzMZRWtMNhWC7o0fA11pBg
	x78zi6ep0ZuL/1CldBOfdS8xCt/izssb+fTb+LwgBAh+mMDE8ST6ZFc7y0DVsJeewoBLuXbc
X-Gm-Gg: AZFdTZeMxT/jk7sDlxHim25zMsPHafhRZ4VPf5gPik1JS9tEBzRl63+TS52dhRiXFQY
	1fQAPQu1stqAV0wKF3FjdyUHaTb9u4RJzDqpi/qbvRLFqOvc/cMH46DZaXV8GY6oSOa0fSZD8BL
	HTq6dkm36b8/6P7WTfFDe0UXipsPJHHNxgw/4I3qmiRGQZz/+QWqHjC+5auEM9zI/qzAbz580cf
	BopNzdma9sJPfduv504/DAvxHyXFxayXc8jXLjtEMVkXsnU3LQM/hxZoaP7W/ELnf/YPwWqmDLG
	diAveAoRC464AjfQ+OMlZrPbdWTyCLEUP0nSg20ZPzhNBSvOhlwngLJnbfpWuS1vsb2WJU5+9nb
	LsfyXAmPybdKr+RtzLWzkVllzxqy+T9oq1uodUNwop6dFRGHUhdIoxL6WdIRpIEwnFIp/e9fCXx
	9hPQmVL6dpPTIc37Bjol9RiDEeDJxW1rcsZKJqfHcXaDrJAKDTO5MaziSJlB8HyjpSl7hyedjgn
	JHKhHuE3vbEUL9OSaTX61htPA+GI08/vKwTcLjctvhtJtNkDlicTPhzAq5uqY7ve6b6WTrFHiZ7
	tIVf9xWotYLLN5atvbYAsp7AEx7ab4C+
X-Received: by 2002:a17:90a:e710:b0:3b0:9941:8d42 with SMTP id 98e67ed59e1d1-3b1b0a0e108mr12498803a91.33.1794896911364;
        Mon, 16 Nov 2026 22:28:31 -0800 (PST)
Received: from Yee-680G4.lan ([46.16.129.105])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18851ecsm4956170a12.13.2026.11.16.22.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:28:31 -0800 (PST)
From: YeeLi <seven.yi.lee@gmail.com>
To: nvdimm@lists.linux.dev
Cc: yeeli <seven.yi.lee@gmail.com>
Subject: [ndctl PATCH 1/2] ndctl/dimm: add missing OPT_END() to key_options
Date: Tue, 17 Nov 2026 14:28:07 +0800
Message-Id: <20261117062808.4004617-2-seven.yi.lee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
References: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
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

From: yeeli <seven.yi.lee@gmail.com>

key_options[] is used by setup-passphrase and update-passphrase, but
it is not terminated with OPT_END().  The option parser walks the
array until it finds an OPTION_END entry, so it runs past the end of
key_options[] and interprets the adjacent sanitize_options[] array.

Before the fix, --crypto-erase is silently accepted and the command
prints the bogus usage:

    $ ndctl setup-passphrase --crypto-erase
    usage: ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]

        -b, --bus <bus-id>    <nmem> must be on a bus with an
                              id/provider of <bus-id>
        -v, --verbose         turn on debug
        -k, --key-handle <key-handle>
                              master encryption key handle
        -m, --master-passphrase
                              use master passphrase
        -b, --bus <bus-id>    <nmem> must be on a bus with an
                              id/provider of <bus-id>
        -v, --verbose         turn on debug
        -c, --crypto-erase    crypto erase a dimm
        -o, --overwrite       overwrite a dimm
        -z, --zero-key        pass in a zero key
        -m, --master-passphrase
                              use master passphrase

After the fix, the same command rejects the invalid option and
prints only the valid options:

    $ ndctl setup-passphrase --crypto-erase
      Error: unknown option `crypto-erase'

    usage: ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]

        -b, --bus <bus-id>    <nmem> must be on a bus with an
                              id/provider of <bus-id>
        -v, --verbose         turn on debug
        -k, --key-handle <key-handle>
                              master encryption key handle
        -m, --master-passphrase
                              use master passphrase

An AddressSanitizer build reports a global-buffer-overflow
immediately after key_options[].

Terminate key_options[] with OPT_END() so parsing stops at the end of
the array.

Tested by building ndctl on the target test system: both passphrase
commands now show only the four expected options, and --crypto-erase
is rejected as an unknown option.

Fixes: 374369ac2f67 ("ndctl: master phassphrase management support")
Signed-off-by: yeeli <seven.yi.lee@gmail.com>
---
 ndctl/dimm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 533ab04..bae7782 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1276,6 +1276,7 @@ static const struct option key_options[] = {
 	BASE_OPTIONS(),
 	KEY_OPTIONS(),
 	MASTER_OPTIONS(),
+	OPT_END(),
 };
 
 static const struct option sanitize_options[] = {
-- 
2.34.1

