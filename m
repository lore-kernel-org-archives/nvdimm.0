Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795262713;
	b=RFJOyfrCoP4AhSWLWL0Yph7SJ4KScNFfgJS3mP8i/64z2XUg+lc8XLZu2DrICse7mfiK
	 W1Phj0qgD7UVcOCtAa+st6ccaiAZQAtbbPcS+hBupSy5AQoC2MkzQ4Qu9xWwLLA5/YwTL
	 JSXe4Eyll8t1re9h+U4RD7cPjbyuaYi18dTTqg4zWpDf1inyu9c0DnKaLkL0CqPoME78b
	 Q15XS75vjQU/WPFewzjzKXYUhvScS2PerOvLZzQ0rWH3/vh+1rugZCrQLXZMqL5WpN+jR
	 mv8estSprsRgZGhlOk+JM9AMRai7Gyq4/BglZbAhOizQbENX1lXdciC9IlGBJq0DsMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795262713;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=2N0f8Hnh84LuhQkUbe8zo17SuoG8Y6Lvd2KUvSPrbpY=;
	b=AU7XMwI0I2dz02xF56owBHgs6eWq1WzEdBiHkphtZGH5sMMNLCEHyijueuvbuzHU6FU7
	 EibwNrMEe6yYP5iELC3zdaHCW8sfvGMxUJsHADNInNemAhhUilqF5JoNbGo0afLHKj8Ts
	 PEVGd1OfAZ7OtHUjcJSAXLwVxrUHx3z02aqJOcuxiG8KJOaT+hnMM9JmDmRcv1UsNtOPo
	 jOJH4T/kbZ9doRvLPuSH09qA7/yqNf/bdstcH4PkobNm5QVJPIbJkB1JtiM3D+KovLgHq
	 gYk6kwSseoQpfMhDy4Mv9Cwhg//ngtgUTpsrisG5e9+C3f+YnnVevEFbp9ud4XCi7oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="CXEStD/R";
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CD1606A320
	for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 12:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80CD1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CXEStD/R
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8c6c06b3321so1561529b3a.3
        for <nvdimm@lists.linux.dev>; Sat, 21 Nov 2026 04:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795262713; x=1795867513; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2N0f8Hnh84LuhQkUbe8zo17SuoG8Y6Lvd2KUvSPrbpY=;
        b=CXEStD/RvLwcAYQsYDkMZ5kDEZ6+da6Y1vUKVoMQQ6BlIRc66hJf5bD6TvOYpPX+h6
         X9jhwQXyaJtlk8vw0Kdyx4K7EdvKvWV1IksFuOqk4/BEn/QGfsqsZLjia7OXl4gd3WF7
         E+t/s3OHBShujAfanhZxEdrVfc0oCM9SIUh8C85tdm+nJSLT3aCrfShuK1XJDjvZORXv
         Kd9qnGoBuRVTZUJytpTdep9DT9yHWaMbnB0VK5RGgSjWqSbr6ioXXyh3+1cUrxcMdZex
         ejhMV9gsqr94kcWHJF5v8Pal9iDpfx5L2y2sgiTv8oNvhHgQp7KwW+dJ/sN0aZ+Gfue0
         /NBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795262713; x=1795867513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2N0f8Hnh84LuhQkUbe8zo17SuoG8Y6Lvd2KUvSPrbpY=;
        b=FXQ0LXgxHf4LMkO2vj7jpRsaCnd5LMZylOkGfuOPo2MkFIgW4DV1u5apLuALJC7lvg
         4X/5HSkQOlTD1tRFze4J3ScfSJ2jO4aVp1vGLvhTnMMtKNcBsqxdrWX740EcJFds790L
         QK/txTh5W2zpSg/50YitOzXzkpaNm2lck5kWL3uxw31nI5I5Ve+MDo98J4FDeTjLqb9U
         uvSdBU+XFhnq6eueTjWLZLmeQVw44yPIpJU+JUr2VtpgQul9xITEm7jAFb2JOvY1GuBx
         S6wtn5wY64W4KfzpITjFpxNhRNuEM9a0aUs8utB3lxRsP/yF+zB/a43BmSSysQ1yQSap
         SxxA==
X-Gm-Message-State: APuU4Z9n1IGvL+Kerb79tYV+KxBavK73AWV14H0Lg0LdPoxEJBfSG26u
	vgeIAmNIPqraTkD3ioBQ5gdn1y3GzebjS5xi4m+v0Ap+nJQi6eCcjHfHA7Oldhfh
X-Gm-Gg: AZFdTZdL8bU5uPjamrMRsgaJZOTWjpVvwSJZ/NmNeiMBXgwtP6d98xTD02hxOsclAsK
	sI3CjFnZObnZvOUwE6HLdX5I7wtLbKpCbTVFDJv7mSs8nrOL6SB9ysqXh1qBaYlo5FmJzlwc2ZS
	kp7nNuwvNkrzSZj7LQJ+N/EXu2AuyjzpM8bVA+UR+bIHWolqsgk5VJqHkLEbnaaDmmoWiozPO2a
	+v9wqteNq9B8AkCcaWRMJ/Sq90VaEAosp0XWk4yArnANVPd4UTCQWHaICrQQFSckktc+vyqH8GS
	3J9IFAEZMEMvSH86KAOT37XxH0MP1XapOTG1FZ69Ay9TtD5Fv8X4wdeGweERgrDzXHHcrYbTdjz
	jmWREjZbIs97sQBHwXPFP39pbPZiuMciSuXwoIhz5sZxkZUR60JRqRJWqGUKZxfOUO5/q9XZVqJ
	Mo9iwuUBqI0EDx1J5YPJggOW4q+M02nH/LG6uLIdNlBOxEaIlJcABCqkOU/MKNWIqivh+7B80jO
	3vuIjXYJJSWu/tQBnemAaaurGWnc9D16xBYeHQqA8ifNuoWEF+ZXZrj82scFzHIINn2bVP9eWcE
	1QMG86U6QqBzRap57tdGRI0IJlPzsm4Da2L0RZlyIy0=
X-Received: by 2002:a05:6a00:4388:b0:8a0:1acb:677a with SMTP id d2e1a72fcca58-8c87d806cf8mr5796736b3a.57.1795262712765;
        Sat, 21 Nov 2026 04:05:12 -0800 (PST)
Received: from localhost.localdomain ([121.134.184.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8706844a0sm2857177b3a.1.2026.11.21.04.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:05:12 -0800 (PST)
From: Unsung Lee <unsung0317@gmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 0/3] cxl/memdev: Fix update-firmware --wait after a failed upload
Date: Sat, 21 Nov 2026 21:05:03 +0900
Message-Id: <20261121120506.1562043-1-unsung0317@gmail.com>
X-Mailer: git-send-email 2.34.1
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

'cxl update-firmware --wait' does not return after an upload that was
cancelled or failed, because it also waits for remaining_size to reach
0 and the kernel leaves remaining_size as it was on errors. Patch 2
waits on the loader status only and extends the cancel test to cover
it. Patch 1 fixes the test helper that was meant to catch a hang like
this but never times out. Patch 3 makes '-F <file> --wait' fail when
the upload ended with data left, so a script can tell a failed update
from a successful one.

Reproducer on a cxl_test or QEMU memdev:

  cxl update-firmware -F fw.bin mem0
  cxl update-firmware --cancel mem0      # while still transferring
  cxl update-firmware --wait mem0        # never returns before patch 2

Tested on a QEMU CXL type 3 memdev, 10 runs per case, each --wait under
'timeout 60' (exit code in parentheses):

  case                              v85         with this series
  normal upload with --wait         returns (0) returns (0)
  --cancel during transfer, --wait  timed out   returns (0)
  --wait alone after a cancel       timed out   returns (0)
  ->prepare() fails (busy), --wait  timed out   returns (1)

and with 'meson test cxl-update-firmware.sh' against cxl_test on
lockdep and KASAN kernels: the series passes; the patched test with the
v85 cxl/memdev.c fails at the new --wait check, and the test of patch 3
fails with the cxl/memdev.c of patch 2. The whole cxl test suite gives
the same results with v85 and with this series.

An LLM-based tool was used to check that the experiments were safe to
run and to drive the repeated test runs.

Patch 3 only sees failures that leave remaining_size non-zero, that is
a ->prepare() failure or a failure or cancel during the transfer. A
failure in the programming step leaves remaining_size at 0 and still
exits 0. Reporting that needs the loader 'error' attribute
("programming:hw-error" etc.), which libcxl does not read; I can add an
API such as cxl_memdev_fw_update_get_error() if that is the preferred
direction. With several memdevs, the command still exits 0 when any of
them succeeded, as for the other memdev commands.

Unsung Lee (3):
  test/cxl-update-firmware: Make wait_complete() honor its timeout
  cxl/memdev: Stop waiting on remaining_size in update-firmware --wait
  cxl/memdev: Fail update-firmware --wait when the upload did not
    complete

 Documentation/cxl/cxl-update-firmware.txt |  5 +++
 cxl/memdev.c                              | 15 ++++++--
 test/cxl-update-firmware.sh               | 42 +++++++++++++++++++----
 3 files changed, 54 insertions(+), 8 deletions(-)

-- 
2.34.1

