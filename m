Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D34E3FC3
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 02:41:32 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso1580992pjq.4
        for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 19:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26TEjhLqvqOOMDWpXjH2SZEl7sRToYoIvj80NNR+lAs=;
        b=Cwowex3YJ2RY0nQm/gvqojd7IQ4TVI3lt2SdmrbWowpkSs4wiG5G+tz4TEOASiJXhW
         gouTAfFaV/Ar3ReNDdxS0Zrbi1yx88QqmipyO1TD/MdaToV7/wWwdXOKbiWq1dsE6DEh
         IxKs5vlT0HxiDorDiKgEC4b0B+PuXK9KqSFmtZpBZXJ2nTaJUITtlq1wWNosLWYt4ari
         wwHEklwyb7TdzXjFTbqWX07JulX6up8kp5huyrEHT+DKVpwZdrYdseKssq7lqkocvsXh
         /54gfcomzQqCi6orD/puduMIPTo0V57pmygg19Sc2/1Hh134p1U0a4675UPBonq9DIts
         f87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26TEjhLqvqOOMDWpXjH2SZEl7sRToYoIvj80NNR+lAs=;
        b=o/Od9iE0ypv7+GXLIIa21InFAsEMHHDOmP99258S051zhkVYJhOV6hy2jyPqfGtOAt
         79o55hoXvBpuFnqIWFIutQKNo+e+m4626jnCmYTgdC/9SWEFIBx/a82METUt1BMX3CoO
         yLjIY/UKDjaSO5HW4P/FvlBxYU2FaCiLlGvcDiPKStvKSwx5n2j57K+iPTbiunr3DdbH
         wcCE2j6+eAkonQvoXBJmPyfnY2RWjvgBR+uLWJiLdMAIQfs9cEj+G2Q6UkOUbW6Cg4RD
         BxHil1oBHQYBKJAljkCAoi5LqJT6Nsa0G1hgXBJ6mFmD7ZP3VeML6sNs5w+8lHehcg5G
         tBVQ==
X-Gm-Message-State: AOAM532+cXOB/M6S9lgtIF3Brz5Mwqdg9ZmcvH+ayXY4fGY5RD9Ho7xU
	r1cvo9GAqV7f4xXWAMoxk7dxZczxmMhSkDLx
X-Google-Smtp-Source: ABdhPJxh/NfcxgtH+0CB1rwDmRviyjzVTpsjzHx7UEXUFVBr9VrZioGXQI21c3RiB/tmSa+w6/TTKA==
X-Received: by 2002:a17:902:9a06:b0:13c:86d8:ce0b with SMTP id v6-20020a1709029a0600b0013c86d8ce0bmr737474plp.51.1631587291648;
        Mon, 13 Sep 2021 19:41:31 -0700 (PDT)
Received: from fedora34.. (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id q21sm9381862pgk.71.2021.09.13.19.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 19:41:31 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH] ndctl, test/monitor: fix conf_file in test_conf_file
Date: Tue, 14 Sep 2021 11:41:19 +0900
Message-Id: <20210914024119.99711-1-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Change conf_file from old config file format to new global config file
format.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 test/monitor.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index 28c5541..c015c11 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -126,7 +126,7 @@ test_conf_file()
 {
 	monitor_dimms=$(get_monitor_dimm)
 	conf_file=$(mktemp)
-	echo "dimm = $monitor_dimms" > $conf_file
+	echo -e "[monitor]\ndimm = $monitor_dimms" > $conf_file
 	start_monitor "-c $conf_file"
 	call_notify
 	check_result "$monitor_dimms"
-- 
2.31.1

