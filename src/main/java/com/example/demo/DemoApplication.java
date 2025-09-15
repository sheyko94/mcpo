package com.example.demo;

import java.util.concurrent.ThreadLocalRandom;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class DemoApplication {

    private static final Logger log = LoggerFactory.getLogger(DemoApplication.class);

    public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@GetMapping("/hello")
	public String hello() {
        log.info("Hello");
		return "ok";
	}

	@GetMapping("/latency")
	public String latency(
			@RequestParam(name = "ms") long ms,
			@RequestParam(name = "jitterMs", required = false, defaultValue = "0") long jitterMs) {
		long jitter = (jitterMs > 0) ? ThreadLocalRandom.current().nextLong(-jitterMs, jitterMs + 1) : 0L;
		long target = clamp(ms + jitter, 0, 30_000);

        log.info("latency with {}ms and {}jitterMs", ms, jitterMs);
		return sleepAndOk(target);
	}

	@GetMapping("/error")
	public String error(@RequestParam(name = "rate", defaultValue = "0.0") double rate) {
		if (rate < 0)
			rate = 0.0;
		if (rate > 1)
			rate = 1.0;
		if (ThreadLocalRandom.current().nextDouble() < rate) {
			throw new RuntimeException("Synthetic failure");
		}
        log.info("error with {}rate", rate);
		return "ok";
	}

	private static String sleepAndOk(long ms) {
		try {
			Thread.sleep(ms);
		} catch (InterruptedException ignored) {
		}
		return "ok";
	}

	private static long clamp(long v, long lo, long hi) {
		return Math.max(lo, Math.min(hi, v));
	}

}
